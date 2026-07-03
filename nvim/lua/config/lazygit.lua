vim.keymap.set("n", "<leader>g", function()
  vim.cmd("tabnew")
  vim.cmd("terminal lazygit")
  vim.cmd("startinsert")

  -- Hide status column / line numbers in LazyGit terminal
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.statuscolumn = ""

  local bufnr = vim.api.nvim_get_current_buf()
  local tabnr = vim.api.nvim_get_current_tabpage()

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = bufnr,
    once = true,
    callback = function()
      vim.schedule(function()
        if vim.api.nvim_tabpage_is_valid(tabnr) then
          vim.api.nvim_set_current_tabpage(tabnr)
          vim.cmd("tabclose")
        end
      end)
    end,
  })
end, {
  desc = "Open lazygit in fullscreen terminal",
})

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
  desc = "Exit terminal mode",
})
