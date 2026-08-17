local lazygit = {
    buf = nil,
    tab = nil,
}

local function close_lazygit_tab()
    if lazygit.tab and vim.api.nvim_tabpage_is_valid(lazygit.tab) then
        vim.api.nvim_set_current_tabpage(lazygit.tab)
        vim.cmd("tabclose")
    end

    lazygit.tab = nil
end

local function cleanup_lazygit()
    local bufnr = lazygit.buf
    local tabnr = lazygit.tab

    lazygit.buf = nil

    vim.schedule(function()
        if tabnr and vim.api.nvim_tabpage_is_valid(tabnr) then
            vim.api.nvim_set_current_tabpage(tabnr)
            vim.cmd("tabclose!")
        end

        lazygit.tab = nil

        if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end)
end

local function configure_lazygit_window(bufnr)
    vim.bo[bufnr].bufhidden = "hide"
    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].swapfile = false

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.statuscolumn = ""

    vim.opt_local.showtabline = 0
end

local function create_lazygit()
    local bufnr = vim.api.nvim_get_current_buf()

    local job_id = vim.fn.jobstart("lazygit", { term = true })
    if job_id == 0 then
        close_lazygit_tab()
        vim.notify("Failed to start LazyGit", vim.log.levels.ERROR)
        return
    end

    lazygit.buf = bufnr

    configure_lazygit_window(bufnr)

    vim.api.nvim_create_autocmd("TermClose", {
        buffer = bufnr,
        once = true,
        callback = cleanup_lazygit,
    })

    -- Prevent the global terminal mapping from leaving terminal mode.
    -- LazyGit receives the two Escape keypresses instead.
    vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", {
        buffer = bufnr,
        remap = false,
        desc = "Pass Escape Escape to LazyGit",
    })

    vim.keymap.set({ "n", "t" }, "q", function()
        close_lazygit_tab()
    end, {
        buffer = bufnr,
        silent = true,
        desc = "Hide LazyGit",
    })
end

vim.keymap.set("n", "<leader>gg", function()
    if lazygit.tab and vim.api.nvim_tabpage_is_valid(lazygit.tab) then
        close_lazygit_tab()
        return
    end

    vim.cmd("tabnew")
    lazygit.tab = vim.api.nvim_get_current_tabpage()

    if lazygit.buf and vim.api.nvim_buf_is_valid(lazygit.buf) then
        vim.api.nvim_set_current_buf(lazygit.buf)
        configure_lazygit_window(lazygit.buf)
    else
        create_lazygit()
    end

    vim.cmd("startinsert")
end, {
    desc = "LazyGit",
})
