return {
    {
        "dmmulroy/ts-error-translator.nvim",
        ft = { "typescript", "typescriptreact" },
        config = function()
            require("ts-error-translator").setup({
                -- Auto-attach to LSP servers for TypeScript diagnostics
                auto_attach = true,

                -- LSP server names to translate diagnostics for
                servers = {
                    "astro",
                    "svelte",
                    "ts_ls",
                    "tsserver", -- deprecated, use ts_ls
                    "typescript-tools",
                    "volar",
                    "vtsls",
                },
            })
        end,
    },
}
