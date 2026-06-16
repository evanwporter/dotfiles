vim.opt.termguicolors = true

-- -- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.sessions")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- vim.cmd.colorscheme("solarized")
--
-- vim.api.nvim_set_hl(0, "Cursor", {
--   fg = "#fdf6e3",
--   bg = "#073642",
-- })
--
-- vim.opt.guicursor = {
--   "n-v-c:block-Cursor",
--   "i-ci-ve:ver25-Cursor",
--   "r-cr:hor20-Cursor",
-- }
