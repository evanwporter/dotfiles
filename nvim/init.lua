vim.opt.termguicolors = true

-- bootstrap lazy.nvim, LazyVim and your plugins
vim.filetype.add({
  extension = {
    v = "verilog",
    vh = "verilog",
    sv = "systemverilog",
    svh = "systemverilog",
  },
})

vim.api.nvim_set_current_dir(vim.env.PWD)

require("config.lazy")
require("config.sessions")
