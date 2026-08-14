local augroup = require("util.autocmd").augroup

local last_non_floating_win

local function is_floating_window(win)
    return vim.api.nvim_win_get_config(win).relative ~= ""
end

local function find_non_floating_window()
    if
        last_non_floating_win
        and vim.api.nvim_win_is_valid(last_non_floating_win)
        and not is_floating_window(last_non_floating_win)
    then
        return last_non_floating_win
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) and not is_floating_window(win) then
            return win
        end
    end
end

-- nvim-dap-view fixes the width of right/left layouts, which also prevents
-- resizing the split border with the mouse. Keep its windows user-resizable.
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("resizable_dap_view"),
    pattern = { "dap-view", "dap-view-term" },
    callback = function()
        vim.wo.winfixwidth = false
        vim.wo.winfixheight = false
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    group = augroup("track_non_floating_window"),
    callback = function()
        local win = vim.api.nvim_get_current_win()

        if not is_floating_window(win) then
            last_non_floating_win = win
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup("redirect_file_from_float"),
    callback = function(event)
        local float_win = vim.api.nvim_get_current_win()

        if not is_floating_window(float_win) then
            last_non_floating_win = float_win
            return
        end

        if vim.bo[event.buf].buftype ~= "" or vim.api.nvim_buf_get_name(event.buf) == "" then
            return
        end

        local target_win = find_non_floating_window()

        if not target_win then
            return
        end

        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) or not vim.api.nvim_win_is_valid(target_win) then
                return
            end

            pcall(vim.api.nvim_win_set_buf, target_win, event.buf)
            pcall(vim.api.nvim_set_current_win, target_win)

            if vim.api.nvim_win_is_valid(float_win) then
                pcall(vim.api.nvim_win_close, float_win, true)
            end
        end)
    end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "checkhealth",
        "dap-float",
        "dbout",
        "gitsigns-blame",
        "grug-far",
        "help",
        "lspinfo",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "notify",
        "qf",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) then
                return
            end

            vim.keymap.set("n", "q", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        if vim.fn.has("nvim-0.13") == 1 then
            vim.hl.hl_op()
        else
            (vim.hl or vim.highlight).on_yank()
        end
    end,
})

-- Source current shell file with <localleader>s
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("source_shell_file"),
    pattern = { "fish", "sh" },
    callback = function(event)
        vim.keymap.set("n", "<localleader>s", function()
            local path = vim.api.nvim_buf_get_name(event.buf)

            if path == "" then
                vim.notify("Cannot source an unnamed buffer", vim.log.levels.WARN)
                return
            end

            local ok, err = pcall(vim.cmd.write)

            if not ok then
                vim.notify("Could not save before sourcing: " .. err, vim.log.levels.ERROR)
                return
            end

            local shell = vim.bo[event.buf].filetype == "fish" and "fish" or "bash"
            local cmd = shell == "fish" and { "fish", "-c", "source $argv[1]", path }
                or { "bash", "-c", 'source "$1"', "bash", path }

            vim.system(cmd, { text = true }, function(result)
                vim.schedule(function()
                    if result.code == 0 then
                        vim.notify("Sourced " .. vim.fn.fnamemodify(path, ":~:."))
                        return
                    end

                    local output = vim.trim((result.stderr or "") .. "\n" .. (result.stdout or ""))

                    if output == "" then
                        output = shell .. " exited with code " .. result.code
                    end

                    vim.notify(output, vim.log.levels.ERROR)
                end)
            end)
        end, {
            buffer = event.buf,
            desc = "Source Shell File",
            silent = true,
        })
    end,
})

-- Enable treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- Enable inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("user_inlay_hints"),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf

        -- Define excluded filetypes here if needed (e.g., { "markdown", "help" })
        local exclude_filetypes = {}

        if
            client
            and client:supports_method("textDocument/inlayHint", { bufnr = buf })
            and vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buftype == ""
            and not vim.tbl_contains(exclude_filetypes, vim.bo[buf].filetype)
        then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        end
    end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- neocmakelsp `signature_help` hack
-- check is there an ) after this character in the current line and there are only spaces between them
local function check_condition()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local i = col + 1
    while i <= #line do
        local c = line:sub(i, i)
        if c == ")" then
            return true
        elseif c:match("%s") then
            i = i + 1
        else
            return false
        end
    end
    return false
end
-- check whether send signature_help request when inserting new text
vim.api.nvim_create_autocmd("InsertCharPre", {
    pattern = { "CMakeLists.txt", "*.cmake" },
    callback = function()
        local char = vim.v.char
        if (char == " " or char == "\n") and check_condition() then
            vim.defer_fn(vim.lsp.buf.signature_help, 20)
        end
    end,
})
-- check whether send signature_help request when enter insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = { "CMakeLists.txt", "*.cmake" },
    callback = function()
        if check_condition() then
            vim.defer_fn(vim.lsp.buf.signature_help, 30)
        end
    end,
})
