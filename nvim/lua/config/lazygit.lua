vim.keymap.set("n", "<leader>gg", function()
    vim.cmd("tabnew")

    -- Hide status column / line numbers in LazyGit terminal
    local bufnr = vim.api.nvim_get_current_buf()
    local tabnr = vim.api.nvim_get_current_tabpage()
    local closing = false

    local function close_lazygit_tab()
        if closing then
            return
        end

        closing = true

        vim.schedule(function()
            if vim.api.nvim_tabpage_is_valid(tabnr) then
                vim.api.nvim_set_current_tabpage(tabnr)
                vim.cmd("tabclose!")
            end

            if vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end)
    end

    vim.bo[bufnr].bufhidden = "wipe"
    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].swapfile = false
    vim.bo[bufnr].buftype = "nofile"

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.statuscolumn = ""
    vim.wo.winbar = ""

    vim.opt_local.showtabline = 0

    local job_id = vim.fn.termopen("lazygit", {
        on_exit = close_lazygit_tab,
    })

    if job_id <= 0 then
        close_lazygit_tab()
        vim.notify("Failed to start LazyGit", vim.log.levels.ERROR)
        return
    end

    -- Prevent the global terminal mapping from leaving terminal mode.
    -- LazyGit receives the two Escape keypresses instead.
    vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", {
        buffer = bufnr,
        remap = false,
        desc = "Pass Escape Escape to LazyGit",
    })

    vim.cmd("startinsert")
end, {
    desc = "LazyGit",
})
