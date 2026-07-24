vim.o.termguicolors = true

vim.cmd.colorscheme("gruvbox-material")

-- Define BlinkPairs highlight groups for rainbow highlights
vim.api.nvim_set_hl(0, "BlinkPairsOrange", { fg = "#fe8019", bold = true })
vim.api.nvim_set_hl(0, "BlinkPairsPurple", { fg = "#d3869b", bold = true })
vim.api.nvim_set_hl(0, "BlinkPairsBlue", { fg = "#83a598", bold = true })
vim.api.nvim_set_hl(0, "BlinkPairsUnmatched", { fg = "#fb4934", bold = true })
vim.api.nvim_set_hl(0, "BlinkPairsMatchParen", { bg = "#504945", bold = true })
