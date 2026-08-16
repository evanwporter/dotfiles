return {
    {
        "saghen/blink.indent",
        cond = not vim.g.vscode,
        event = "VeryLazy",

        --- @module 'blink.indent'
        --- @type blink.indent.Config
        opts = {},
    },
}
