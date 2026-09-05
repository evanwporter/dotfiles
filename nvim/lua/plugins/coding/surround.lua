return {
    {
        "kylechui/nvim-surround",
        enabled = false,
        init = function()
            -- Disable default keymaps
            vim.g.nvim_surround_no_mappings = true
        end,
        keys = {
            { "sa", "<Plug>(nvim-surround-normal)", mode = "n", desc = "Add surround" },
            { "sd", "<Plug>(nvim-surround-delete)", mode = "n", desc = "Delete surround" },
            { "sr", "<Plug>(nvim-surround-change)", mode = "n", desc = "Replace surround" },
            { "sa", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Add surround" },
        },
        opts = {},
    },
}
