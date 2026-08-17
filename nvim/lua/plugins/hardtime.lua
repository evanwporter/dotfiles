return {
    {
        "MunifTanjim/nui.nvim",
        optional = true,
        opts = {},
    },
    {
        "m4xshen/hardtime.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            disabled_keys = {
                ["<Left>"] = false,
                ["<Right>"] = false,
            },
            -- disable_mouse = false,
        },
    },
}
