-- Markdown rendering
-- Installation handled by lua/sources.lua

return {
    "render-markdown.nvim",
    lazy = true,
    ft = { "markdown" },
    before = function()
        require("lz.n").trigger_load("mini.icons")
    end,
    after = function()
        require("render-markdown").setup({})
    end,
}
