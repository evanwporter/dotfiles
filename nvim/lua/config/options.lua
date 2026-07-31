vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.showtabline = 0

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.signcolumn = "yes"

vim.opt.confirm = true

vim.opt.clipboard = "unnamedplus"

vim.env.PATH = vim.fn.expand("~/.local/share/nvim/tools/bin") .. ":" .. vim.env.PATH

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 0
vim.opt.foldtext = ""

vim.opt.fillchars = {
    fold = " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
}

-- vim.cmd.syntax("manual")
