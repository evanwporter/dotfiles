local term = {
    buf = nil,
    tab = nil,
}

local function cleanup_no_name_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.bo[buf].buftype
        local modified = vim.bo[buf].modified

        if name == "" and buftype == "" and not modified then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
    end
end

local function close_terminal()
    if term.tab and vim.api.nvim_tabpage_is_valid(term.tab) then
        vim.api.nvim_set_current_tabpage(term.tab)
        vim.cmd("tabclose")
    end

    term.tab = nil

    vim.schedule(cleanup_no_name_buffers)
end

local function create_terminal()
    vim.cmd("terminal")
    term.buf = vim.api.nvim_get_current_buf()

    vim.bo[term.buf].buflisted = false
end

local function toggle_terminal()
    -- If terminal tab is open, hide it
    if term.tab and vim.api.nvim_tabpage_is_valid(term.tab) then
        close_terminal()
        return
    end

    vim.cmd("tabnew")
    term.tab = vim.api.nvim_get_current_tabpage()

    if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
        vim.api.nvim_set_current_buf(term.buf)
    else
        create_terminal()
    end

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.statuscolumn = ""
    vim.opt_local.showtabline = 0

    vim.cmd("startinsert")
end

for _, lhs in ipairs({ "<C-/>", "<C-_>" }) do
    vim.keymap.set({ "n", "t" }, lhs, toggle_terminal, {
        desc = "Toggle fullscreen terminal",
    })
end

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
    desc = "Exit terminal mode",
})
