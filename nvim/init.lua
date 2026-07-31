-- Capture startup time as early as possible
vim.g.start_time = vim.fn.reltime()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load autocmds BEFORE plugin management so PackChanged fires
require("core.autocmd")

-- Setup vim.pack + lz.n for plugin management
require("nvim_pack")

-- Capture time after plugins are set up
vim.g.plugins_loaded_time = vim.fn.reltime(vim.g.start_time)

-- Load core modules (diagnostics, terminal, statusline, etc)
require("core")
require("config")

-- Capture final startup time after everything loads
vim.schedule(function()
    vim.g.startup_time = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time)) * 1000
end)
