vim.opt.sessionoptions = { "tabpages", "winsize" }

local session_file = ".git/session.vim"

-- Helper to check if current working directory has a valid .git directory/file
local function is_git_repo()
    return vim.fn.isdirectory(".git") == 1 or vim.fn.filereadable(".git") == 1
end

-- Load session on startup if .git exists and session file exists
vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        -- Only load session if nvim was opened without file arguments (e.g. `nvim`)
        if vim.fn.argc() == 0 and is_git_repo() and vim.fn.filereadable(session_file) == 1 then
            vim.cmd("source " .. session_file)
        end
    end,
})

-- Save session on exit if .git exists
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if not is_git_repo() then
            return
        end

        -- Clean up hidden/invisible buffers that aren't displayed in any window
        local visible_bufs = {}
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                visible_bufs[vim.api.nvim_win_get_buf(win)] = true
            end
        end

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and not visible_bufs[buf] then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end

        -- Save session inside .git/ so it won't dirty working tree
        vim.cmd("mksession! " .. session_file)
    end,
})
