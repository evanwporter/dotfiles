-- mason.nvim - Portable package manager for LSP servers, DAP servers, linters, formatters
-- Installation handled by lua/sources.lua

return {
    "mason.nvim",
    lazy = false,
    after = function()
        require("mason").setup({})
    end,
}
