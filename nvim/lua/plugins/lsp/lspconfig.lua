-- nvim-lspconfig - LSP client configurations
-- Installation handled by lua/sources.lua

return {
    "nvim-lspconfig",
    lazy = false,
    before = function()
        -- Load schemastore before lspconfig
        require("lz.n").trigger_load("schemastore.nvim")
    end,
    after = function()
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        -- Load all LSP server configurations after lspconfig and schemastore are ready
        require("config.lsp")
    end,
}
