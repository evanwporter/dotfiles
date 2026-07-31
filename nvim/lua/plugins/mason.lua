return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        lazy = false,
        opts = {}
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_installation = true,
            ensure_installed = {
                "python",
            },
            handlers = {},
        },
    },
}
