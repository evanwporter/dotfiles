local term = {
  buf = nil,
  tab = nil,
}

local function cleanup_no_name_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    local buftype = vim.bo[buf].buftype
    local modified = vim.bo[buf].modified

    -- Delete empty [No Name] buffers, but do not delete active terminals or modified buffers
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

  if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    pcall(vim.api.nvim_buf_delete, term.buf, { force = true })
  end

  term.buf = nil
  term.tab = nil

  vim.schedule(cleanup_no_name_buffers)
end

local function toggle_terminal()
  if term.tab and vim.api.nvim_tabpage_is_valid(term.tab) then
    close_terminal()
    return
  end

  vim.cmd("tabnew")
  term.tab = vim.api.nvim_get_current_tabpage()

  vim.cmd("terminal")
  term.buf = vim.api.nvim_get_current_buf()

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.statuscolumn = ""

  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminal, {
  desc = "Toggle fullscreen terminal",
})

vim.keymap.set({ "n", "t" }, "<C-_>", toggle_terminal, {
  desc = "Toggle fullscreen terminal",
})

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
  desc = "Exit terminal mode",
})
