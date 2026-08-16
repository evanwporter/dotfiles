return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        cond = not vim.g.vscode,
        dependencies = { "nvim-mini/mini.icons" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        ft = { "markdown" },
    },
}
