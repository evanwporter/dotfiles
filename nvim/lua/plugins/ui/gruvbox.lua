-- Gruvbox Material theme configuration
-- Installation handled by lua/sources.lua

return {
    "gruvbox-material",
    -- Don't lazy-load the theme, load it immediately
    beforeAll = function()
        vim.o.background = "dark"
        vim.g.gruvbox_material_background = "medium"
        vim.g.gruvbox_material_better_performance = 1

        -- Load the plugin immediately
        vim.cmd.packadd("gruvbox-material")
        vim.cmd.colorscheme("gruvbox-material")

        -- Define BlinkPairs highlight groups for rainbow highlights
        vim.api.nvim_set_hl(0, "BlinkPairsOrange", { fg = "#fe8019", bold = true })
        vim.api.nvim_set_hl(0, "BlinkPairsPurple", { fg = "#d3869b", bold = true })
        vim.api.nvim_set_hl(0, "BlinkPairsBlue", { fg = "#83a598", bold = true })
        vim.api.nvim_set_hl(0, "BlinkPairsUnmatched", { fg = "#fb4934", bold = true })
        vim.api.nvim_set_hl(0, "BlinkPairsMatchParen", { bg = "#504945", bold = true })
    end,
}
