return {
    {
        "kylechui/nvim-surround",
        -- version = "^4.0.0",
        -- event = "VeryLazy",
        init = function()
            -- Disable default keymaps (ys, ds, cs, S, etc.)
            vim.g.nvim_surround_no_mappings = true
        end,
        keys = {
            -- Normal mode: Add surround
            { "ys", "<Plug>(nvim-surround-normal)", desc = "Add surround around motion" },
            { "yss", "<Plug>(nvim-surround-normal-cur)", desc = "Add surround around current line" },
            { "yS", "<Plug>(nvim-surround-normal-line)", desc = "Add surround around motion (new lines)" },
            { "ySS", "<Plug>(nvim-surround-normal-cur-line)", desc = "Add surround around line (new lines)" },

            -- Normal mode: Delete & Change
            { "ds", "<Plug>(nvim-surround-delete)", desc = "Delete surrounding pair" },
            { "cs", "<Plug>(nvim-surround-change)", desc = "Change surrounding pair" },
            { "gcs", "<Plug>(nvim-surround-change-line)", desc = "Change surrounding pair (new lines)" },

            -- Visual mode: Add surround
            { "s", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Add surround around selection" },
            {
                "gs",
                "<Plug>(nvim-surround-visual-line)",
                mode = "x",
                desc = "Add surround around selection (new lines)",
            },
        },
    },
}
