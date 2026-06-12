-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

local function set_neotest_highlights()
  vim.api.nvim_set_hl(0, "NeotestFile", { fg = "#2aa198" }) -- cyan
  vim.api.nvim_set_hl(0, "NeotestDir", { fg = "#268bd2" }) -- blue
  vim.api.nvim_set_hl(0, "NeotestNamespace", { fg = "#6c71c4" }) -- violet
  vim.api.nvim_set_hl(0, "NeotestTest", { fg = "#859900" }) -- green
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_neotest_highlights,
})

set_neotest_highlights()
