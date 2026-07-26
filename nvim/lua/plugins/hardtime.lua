return {
    {
        "m4xshen/hardtime.nvim",
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
