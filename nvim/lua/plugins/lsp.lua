return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "b0o/schemastore.nvim",
        },
        config = function()
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },
}
