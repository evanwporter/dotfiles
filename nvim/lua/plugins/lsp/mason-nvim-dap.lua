-- mason-nvim-dap - Bridge between mason and nvim-dap
-- Installation handled by lua/sources.lua

return {
    "mason-nvim-dap.nvim",
    lazy = true,
    cmd = { "DapInstall", "DapUninstall" },
    before = function()
        -- Ensure dependencies are loaded
        require("lz.n").trigger_load({ "mason.nvim", "nvim-dap" })
    end,
    after = function()
        require("mason-nvim-dap").setup({
            automatic_installation = true,
            ensure_installed = {
                "python",
            },
            handlers = {},
        })
    end,
}
