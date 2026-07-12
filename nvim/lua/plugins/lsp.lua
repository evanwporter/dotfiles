return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            for server, server_opts in pairs(require("util.lsp").servers) do
                vim.lsp.config(server, server_opts)
                vim.lsp.enable(server)
            end
        end,
    },
}
