return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",

        ---@module 'lazydev.nvim'
        ---@type lazydev.Config
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "lazy.nvim", words = { "LazyVim" } },
                { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        opts = {
            sources = {
                per_filetype = {
                    lua = { inherit_defaults = true, "lazydev" },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
        },
    },
}
