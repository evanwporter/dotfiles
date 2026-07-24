local M = {}

local api = vim.api
local fn = vim.fn

local WINBAR_EXPR = "%!v:lua.require'core.bufferline'.render()"

local MORE_LEFT = "  "
local MORE_RIGHT = "  "

local excluded_filetypes = {
    ["neo-tree"] = true,
    NvimTree = true,
    oil = true,
    Trouble = true,
    lazy = true,

    snacks_picker = true,
    snacks_picker_input = true,
    snacks_picker_list = true,
    snacks_picker_preview = true,
    snacks_dashboard = true,
    snacks_terminal = true,

    ["dap-repl"] = true,
    ["dap-view"] = true,
    ["dap-view-term"] = true,
    ["dap-view-hover"] = true,
    ["dap-view-help"] = true,
    dapui_console = true,
    dapui_watches = true,
    dapui_stacks = true,
    dapui_breakpoints = true,
    dapui_scopes = true,
    ["dapui-repl"] = true,
}

local function set_highlights()
    api.nvim_set_hl(0, "BufferLineCurrent", {
        link = "TabLineSel",
    })

    api.nvim_set_hl(0, "BufferLineVisible", {
        link = "TabLine",
    })

    api.nvim_set_hl(0, "BufferLineInactive", {
        link = "TabLineFill",
    })

    api.nvim_set_hl(0, "BufferLineModified", {
        link = "DiagnosticWarn",
    })

    api.nvim_set_hl(0, "BufferLineFill", {
        link = "WinBar",
    })

    api.nvim_set_hl(0, "BufferLineMore", {
        link = "Comment",
    })
end

set_highlights()

---@param text string
---@return integer
local function display_width(text)
    return fn.strdisplaywidth(text)
end

---@return integer
local function statusline_winid()
    local winid = vim.g.statusline_winid

    if type(winid) == "number" and api.nvim_win_is_valid(winid) then
        return winid
    end

    return api.nvim_get_current_win()
end

---@return integer
local function statusline_bufnr()
    return api.nvim_win_get_buf(statusline_winid())
end

---@param text string
---@param max_width integer
---@param from_end? boolean
---@return string
local function truncate(text, max_width, from_end)
    if max_width <= 0 then
        return ""
    end

    if display_width(text) <= max_width then
        return text
    end

    local positions = vim.str_utf_pos(text)
    local result = {}
    local width = 0

    local first = from_end and #positions or 1
    local last = from_end and 1 or #positions
    local step = from_end and -1 or 1

    for index = first, last, step do
        local next_position = positions[index + 1]

        local character = text:sub(positions[index], next_position and next_position - 1 or #text)

        local character_width = display_width(character)

        if width + character_width > max_width then
            break
        end

        if from_end then
            table.insert(result, 1, character)
        else
            result[#result + 1] = character
        end

        width = width + character_width
    end

    return table.concat(result)
end

---@param bufnr integer
---@return boolean
local function is_normal_buffer(bufnr)
    if not api.nvim_buf_is_valid(bufnr) then
        return false
    end

    if not vim.bo[bufnr].buflisted then
        return false
    end

    if vim.bo[bufnr].buftype ~= "" then
        return false
    end

    local filetype = vim.bo[bufnr].filetype

    if filetype:match("^snacks") then
        return false
    end

    if excluded_filetypes[filetype] then
        return false
    end

    return true
end

---@param winid integer
---@return boolean
local function should_show_winbar(winid)
    if not api.nvim_win_is_valid(winid) then
        return false
    end

    local bufnr = api.nvim_win_get_buf(winid)

    if not api.nvim_buf_is_valid(bufnr) then
        return false
    end

    local filetype = vim.bo[bufnr].filetype
    local buftype = vim.bo[bufnr].buftype

    if buftype ~= "" then
        return false
    end

    if filetype:match("^snacks") then
        return false
    end

    if filetype:match("^dapui") then
        return false
    end

    if excluded_filetypes[filetype] then
        return false
    end

    return true
end

---@return integer[]
local function get_buffers()
    local buffers = {}

    for _, bufnr in ipairs(api.nvim_list_bufs()) do
        if is_normal_buffer(bufnr) then
            buffers[#buffers + 1] = bufnr
        end
    end

    table.sort(buffers, function(left, right)
        return left < right
    end)

    return buffers
end

---@param bufnr integer
---@return string
local function get_buffer_filename(bufnr)
    local name = api.nvim_buf_get_name(bufnr)

    if name == "" then
        return "[No Name]"
    end

    return fn.fnamemodify(name, ":t")
end

---@param buffers integer[]
---@return table<integer, string>
local function get_buffer_names(buffers)
    ---@type table<string, integer>
    local filename_counts = {}

    for _, bufnr in ipairs(buffers) do
        local filename = get_buffer_filename(bufnr)

        filename_counts[filename] = (filename_counts[filename] or 0) + 1
    end

    ---@type table<integer, string>
    local names = {}

    for _, bufnr in ipairs(buffers) do
        local full_name = api.nvim_buf_get_name(bufnr)
        local filename = get_buffer_filename(bufnr)

        if filename_counts[filename] > 1 and full_name ~= "" then
            names[bufnr] = fn.fnamemodify(full_name, ":~:.")
        else
            names[bufnr] = filename
        end
    end

    return names
end

---@param bufnr integer
---@param name string
---@param is_current boolean
---@return string
local function get_label(bufnr, name, is_current)
    local left = is_current and "▌ " or " "
    local right = is_current and " ▐" or " "

    if vim.bo[bufnr].modified then
        return string.format("%s%s ●%s", left, name, right)
    end

    return string.format("%s%s%s", left, name, right)
end

---@param bufnr integer
---@param label string
---@param current_buf integer
---@return string
local function format_buffer(bufnr, label, current_buf)
    local highlight

    if bufnr == current_buf then
        highlight = "BufferLineCurrent"
    elseif fn.bufwinid(bufnr) ~= -1 then
        highlight = "BufferLineVisible"
    else
        highlight = "BufferLineInactive"
    end

    return string.format("%%#%s#%%%d@v:lua.BufferLineClick@%s%%T", highlight, bufnr, label)
end

---@param buffers integer[]
---@param current_buf integer
---@return integer
local function find_current_index(buffers, current_buf)
    for index, bufnr in ipairs(buffers) do
        if bufnr == current_buf then
            return index
        end
    end

    return 1
end

---@param minwid integer
---@param clicks integer
---@param button string
---@param modifiers string
_G.BufferLineClick = function(minwid, clicks, button, modifiers)
    local bufnr = tonumber(minwid)

    if not bufnr or not api.nvim_buf_is_valid(bufnr) then
        return
    end

    if button == "m" then
        vim.schedule(function()
            if not api.nvim_buf_is_valid(bufnr) then
                return
            end

            local ok, error_message = pcall(api.nvim_buf_delete, bufnr, { force = false })

            if not ok then
                vim.notify(error_message, vim.log.levels.WARN, { title = "Bufferline" })
            end
        end)

        return
    end

    if button ~= "l" then
        return
    end

    vim.schedule(function()
        if api.nvim_buf_is_valid(bufnr) then
            api.nvim_set_current_buf(bufnr)
        end
    end)
end

---@return string
M.render = function()
    local winid = statusline_winid()

    if not should_show_winbar(winid) then
        return ""
    end

    local buffers = get_buffers()

    if #buffers == 0 then
        return "%#BufferLineFill#"
    end

    local current_buf = statusline_bufnr()
    local names = get_buffer_names(buffers)

    local labels = {}
    local widths = {}

    for _, bufnr in ipairs(buffers) do
        labels[bufnr] = get_label(bufnr, names[bufnr], bufnr == current_buf)
        widths[bufnr] = display_width(labels[bufnr])
    end

    local available_width = api.nvim_win_get_width(winid)
    local total_width = 0

    for _, bufnr in ipairs(buffers) do
        total_width = total_width + widths[bufnr]
    end

    if total_width <= available_width then
        local result = {}

        for _, bufnr in ipairs(buffers) do
            result[#result + 1] = format_buffer(bufnr, labels[bufnr], current_buf)
        end

        result[#result + 1] = "%#BufferLineFill#"

        return table.concat(result)
    end

    local current_index = find_current_index(buffers, current_buf)

    local left_index = current_index
    local right_index = current_index

    local left_more_width = display_width(MORE_LEFT)
    local right_more_width = display_width(MORE_RIGHT)

    local used_width = widths[buffers[current_index]]

    while true do
        local added = false

        if left_index > 1 then
            local candidate = buffers[left_index - 1]

            local reserve_left = left_index - 1 > 1 and left_more_width or 0

            local reserve_right = right_index < #buffers and right_more_width or 0

            if used_width + widths[candidate] + reserve_left + reserve_right <= available_width then
                left_index = left_index - 1
                used_width = used_width + widths[candidate]
                added = true
            end
        end

        if right_index < #buffers then
            local candidate = buffers[right_index + 1]

            local reserve_left = left_index > 1 and left_more_width or 0

            local reserve_right = right_index + 1 < #buffers and right_more_width or 0

            if used_width + widths[candidate] + reserve_left + reserve_right <= available_width then
                right_index = right_index + 1
                used_width = used_width + widths[candidate]
                added = true
            end
        end

        if not added then
            break
        end
    end

    local show_left_more = left_index > 1
    local show_right_more = right_index < #buffers

    local reserved_width = 0

    if show_left_more then
        reserved_width = reserved_width + left_more_width
    end

    if show_right_more then
        reserved_width = reserved_width + right_more_width
    end

    if left_index == right_index then
        local bufnr = buffers[current_index]
        local max_label_width = available_width - reserved_width

        if widths[bufnr] > max_label_width then
            labels[bufnr] = truncate(labels[bufnr], max_label_width)
        end
    end

    local result = {}

    if show_left_more then
        result[#result + 1] = "%#BufferLineMore#" .. MORE_LEFT
    end

    for index = left_index, right_index do
        local bufnr = buffers[index]

        result[#result + 1] = format_buffer(bufnr, labels[bufnr], current_buf)
    end

    if show_right_more then
        result[#result + 1] = "%#BufferLineMore#" .. MORE_RIGHT
    end

    result[#result + 1] = "%#BufferLineFill#"

    return table.concat(result)
end

local function update_window(winid)
    if not api.nvim_win_is_valid(winid) then
        return
    end

    if should_show_winbar(winid) then
        vim.wo[winid].winbar = WINBAR_EXPR
    else
        -- Don't clear winbar if it's set by another plugin (like dap-ui)
        local current_winbar = vim.wo[winid].winbar
        if current_winbar == WINBAR_EXPR or current_winbar == "" then
            vim.wo[winid].winbar = ""
        end
    end
end

local function update_all_windows()
    for _, winid in ipairs(api.nvim_list_wins()) do
        update_window(winid)
    end
end

-- Disable Neovim's global tabline. The bufferline is displayed
-- independently in each normal window through the winbar.
vim.opt.showtabline = 0
vim.opt.tabline = ""

local group = api.nvim_create_augroup("CustomBufferLine", { clear = true })

api.nvim_create_autocmd({
    "BufEnter",
    "BufWinEnter",
    "FileType",
    "WinEnter",
}, {
    group = group,
    callback = function()
        update_window(api.nvim_get_current_win())
    end,
})

api.nvim_create_autocmd({
    "BufAdd",
    "BufDelete",
    "BufModifiedSet",
    "BufWinEnter",
    "BufWinLeave",
    "WinClosed",
}, {
    group = group,
    callback = function()
        vim.schedule(function()
            update_all_windows()
            vim.cmd.redrawstatus()
        end)
    end,
})

api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
        set_highlights()
        update_all_windows()
        vim.cmd.redrawstatus()
    end,
})

vim.schedule(function()
    update_all_windows()
    vim.cmd.redrawstatus()
end)

return M
