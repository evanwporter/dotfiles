vim.opt.sessionoptions = { "tabpages", "winsize" }

local function get_session_file()
    local result = vim.system({ "git", "rev-parse", "--absolute-git-dir" }, { text = true }):wait()
    if result.code ~= 0 then
        return nil
    end

    local git_dir = vim.trim(result.stdout or "")
    if git_dir == "" then
        return nil
    end

    return git_dir .. "/session.vim"
end

local function is_path_outside_cwd(name)
    if name == "" then
        return false
    end

    local cwd = vim.fs.normalize(vim.fn.getcwd(-1, -1))
    local path = vim.fs.normalize(vim.fn.fnamemodify(name, ":p"))
    return path ~= cwd and not vim.startswith(path, cwd .. "/")
end

local function is_buffer_outside_cwd(buf)
    return vim.bo[buf].buftype == "" and is_path_outside_cwd(vim.api.nvim_buf_get_name(buf))
end

-- Load the session from Git's metadata directory. Resolving it through Git
-- also supports worktrees and submodules, where .git is a pointer file.
vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        local session_file = get_session_file()
        -- Only load session if nvim was opened without file arguments (e.g. `nvim`)
        if vim.fn.argc() == 0 and session_file and vim.fn.filereadable(session_file) == 1 then
            vim.cmd("source " .. vim.fn.fnameescape(session_file))
        end
    end,
})

-- Save the session on exit when the CWD belongs to a Git repository.
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local session_file = get_session_file()
        if not session_file then
            return
        end

        -- Clean up hidden buffers and files outside the CWD before saving.
        local visible_bufs = {}
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                visible_bufs[vim.api.nvim_win_get_buf(win)] = true
            end
        end

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if
                vim.api.nvim_buf_is_valid(buf)
                and vim.bo[buf].buflisted
                and (not visible_bufs[buf] or is_buffer_outside_cwd(buf))
            then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end

        -- mksession also persists the argument list independently of buffers.
        for _, path in ipairs(vim.fn.argv()) do
            if is_path_outside_cwd(path) then
                vim.cmd("silent! argdelete " .. vim.fn.fnameescape(path))
            end
        end

        -- Save session inside .git/ so it won't dirty working tree
        vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
    end,
})
