local CHARS = {
    vertical = "│",
    vertical_right = "├",
    horizontal_up = "┴",
    cross = "┼",
    up_right = "└",
    horizontal = "─",
}

local WRAP_PADDING = 2
local VIRTUAL_LINES = {
    only_current_line = true,
    wrap_long_lines = true,
    highlight_whole_line = false,
}

local HIGHLIGHTS = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
    [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
}

local SPACE = "space"
local DIAGNOSTIC = "diagnostic"
local OVERLAP = "overlap"
local BLANK = "blank"

local function display_width(text)
    return vim.fn.strdisplaywidth(text)
end

local function distance_between_cols(bufnr, lnum, start_col, end_col)
    return vim.api.nvim_buf_call(bufnr, function()
        local start = vim.fn.virtcol({ lnum + 1, start_col })
        local finish = vim.fn.virtcol({ lnum + 1, end_col + 1 })
        return finish - 1 - start
    end)
end

local function window_content_width(bufnr)
    local winid = vim.fn.bufwinid(bufnr)
    if winid == -1 then
        return vim.o.columns
    end
    local info = vim.fn.getwininfo(winid)[1]
    return vim.api.nvim_win_get_width(winid) - (info and info.textoff or 0)
end

local function wrap_line(text, width)
    if width < 1 or display_width(text) <= width then
        return { text }
    end

    local lines = {}
    local line = ""
    local word = ""
    local function flush_word()
        if word == "" then
            return
        end
        local candidate = line == "" and word or line .. " " .. word
        if display_width(candidate) <= width then
            line = candidate
            word = ""
            return
        end
        if line ~= "" then
            table.insert(lines, line)
            line = ""
        end
        while display_width(word) > width do
            local take = vim.fn.strchars(word)
            while take > 1 and display_width(vim.fn.strcharpart(word, 0, take)) > width do
                take = take - 1
            end
            table.insert(lines, vim.fn.strcharpart(word, 0, take))
            word = vim.fn.strcharpart(word, take)
        end
        line = word
        word = ""
    end

    for _, character in ipairs(vim.fn.split(text, "\\zs")) do
        if character:match("%s") then
            flush_word()
        else
            word = word .. character
        end
    end
    flush_word()
    if line ~= "" then
        table.insert(lines, line)
    end
    return #lines > 0 and lines or { "" }
end

local function wrap_message(message, width)
    local lines = {}
    for source_line in (message .. "\n"):gmatch("(.-)\n") do
        vim.list_extend(lines, wrap_line(source_line, width))
    end
    return lines
end

local function chunks_width(chunks)
    local width = 0
    for _, chunk in ipairs(chunks) do
        width = width + display_width(chunk[1])
    end
    return width
end

local function render(namespace, bufnr, diagnostics)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        return
    end
    table.sort(diagnostics, function(a, b)
        return a.lnum == b.lnum and a.col < b.col or a.lnum < b.lnum
    end)
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
    if #diagnostics == 0 then
        return
    end

    local line_stacks = {}
    local previous_line = -1
    local previous_col = 0
    for _, diagnostic in ipairs(diagnostics) do
        line_stacks[diagnostic.lnum] = line_stacks[diagnostic.lnum] or {}
        local stack = line_stacks[diagnostic.lnum]
        if diagnostic.lnum ~= previous_line then
            table.insert(
                stack,
                { SPACE, string.rep(" ", distance_between_cols(bufnr, diagnostic.lnum, 0, diagnostic.col)) }
            )
        elseif diagnostic.col ~= previous_col then
            local distance = distance_between_cols(bufnr, diagnostic.lnum, previous_col + 1, diagnostic.col)
            table.insert(stack, { SPACE, string.rep(" ", math.max(0, distance)) })
        else
            table.insert(stack, { OVERLAP, diagnostic.severity })
        end
        table.insert(stack, { diagnostic.message:find("^%s*$") and BLANK or DIAGNOSTIC, diagnostic })
        previous_line = diagnostic.lnum
        previous_col = diagnostic.col
    end

    local content_width = window_content_width(bufnr)

    for lnum, elements in pairs(line_stacks) do
        local virtual_lines = {}
        for index = #elements, 1, -1 do
            if elements[index][1] == DIAGNOSTIC then
                local diagnostic = elements[index][2]
                local empty_highlight = ""
                local left = {}
                local overlap = false
                local multi = 0
                for left_index = 1, index - 1 do
                    local element_type = elements[left_index][1]
                    local data = elements[left_index][2]
                    if element_type == SPACE then
                        local text = multi == 0 and data or string.rep(CHARS.horizontal, #data)
                        table.insert(left, { text, multi == 0 and empty_highlight or HIGHLIGHTS[diagnostic.severity] })
                    elseif element_type == DIAGNOSTIC then
                        if elements[left_index + 1][1] ~= OVERLAP then
                            table.insert(left, { CHARS.vertical, HIGHLIGHTS[data.severity] })
                        end
                        overlap = false
                    elseif element_type == BLANK then
                        table.insert(left, {
                            multi == 0 and CHARS.up_right or CHARS.horizontal_up,
                            HIGHLIGHTS[data.severity],
                        })
                        multi = multi + 1
                    elseif element_type == OVERLAP then
                        overlap = true
                    end
                end

                local center_symbol
                if overlap and multi > 0 then
                    center_symbol = CHARS.cross
                elseif overlap then
                    center_symbol = CHARS.vertical_right
                elseif multi > 0 then
                    center_symbol = CHARS.horizontal_up
                else
                    center_symbol = CHARS.up_right
                end
                local center = {
                    {
                        center_symbol .. string.rep(CHARS.horizontal, 4) .. " ",
                        HIGHLIGHTS[diagnostic.severity],
                    },
                }
                local message = diagnostic.code and string.format("%s: %s", diagnostic.code, diagnostic.message)
                    or diagnostic.message
                local available_width =
                    math.max(1, content_width - chunks_width(left) - chunks_width(center) - WRAP_PADDING)
                local message_lines = wrap_message(message, available_width)

                for _, message_line in ipairs(message_lines) do
                    local virtual_line = {}
                    vim.list_extend(virtual_line, left)
                    vim.list_extend(virtual_line, center)
                    table.insert(virtual_line, { message_line, HIGHLIGHTS[diagnostic.severity] })
                    table.insert(virtual_lines, virtual_line)
                    if overlap then
                        center = {
                            { CHARS.vertical, HIGHLIGHTS[diagnostic.severity] },
                            { "     ", empty_highlight },
                        }
                    else
                        center = { { "      ", empty_highlight } }
                    end
                end
            end
        end
        vim.api.nvim_buf_set_extmark(bufnr, namespace, lnum, 0, { virt_lines = virtual_lines })
    end
end

local function hide(namespace, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
end

local function render_current_line(diagnostics, namespace, bufnr)
    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local filtered = vim.tbl_filter(function(diagnostic)
        return diagnostic.end_lnum and current_line >= diagnostic.lnum and current_line <= diagnostic.end_lnum
            or current_line == diagnostic.lnum
    end, diagnostics)
    render(namespace, bufnr, filtered)
end

vim.diagnostic.handlers.virtual_lines = {
    show = function(namespace, bufnr, diagnostics)
        local diagnostic_namespace = vim.diagnostic.get_namespace(namespace)
        if not diagnostic_namespace.user_data.virtual_lines_namespace then
            diagnostic_namespace.user_data.virtual_lines_namespace = vim.api.nvim_create_namespace("")
        end

        render_current_line(diagnostics, diagnostic_namespace.user_data.virtual_lines_namespace, bufnr)
    end,
    hide = function(namespace, bufnr)
        local diagnostic_namespace = vim.diagnostic.get_namespace(namespace)
        if diagnostic_namespace.user_data.virtual_lines_namespace then
            hide(diagnostic_namespace.user_data.virtual_lines_namespace, bufnr)
        end
    end,
}

local default_virtual_text = vim.diagnostic.handlers.virtual_text
vim.diagnostic.handlers.virtual_text = {
    show = function(namespace, bufnr, diagnostics, opts)
        local current_line
        if vim.diagnostic.config().virtual_lines and bufnr == vim.api.nvim_get_current_buf() then
            current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
        end

        default_virtual_text.show(namespace, bufnr, vim.tbl_filter(function(diagnostic)
            return diagnostic.lnum ~= current_line
        end, diagnostics), opts)
    end,
    hide = default_virtual_text.hide,
}

vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
    },
    virtual_lines = VIRTUAL_LINES,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        },
    },
    float = {
        border = "rounded",
        source = true,
        focusable = true,
        focus = false,
    },
})

vim.keymap.set("n", "<leader>xl", function()
    local current = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_lines = current and false or VIRTUAL_LINES,
    })
end, { desc = "Toggle diagnostic lines" })

vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged", "ModeChanged", "WinResized" }, {
    group = vim.api.nvim_create_augroup("diagnostic_redraw", { clear = true }),
    callback = function()
        pcall(vim.diagnostic.show)
    end,
})
