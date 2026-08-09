return {
    {
        "folke/which-key.nvim",
        dependencies = {
            "nvim-mini/mini.icons",
        },
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            preset = "helix",
            delay = 100,
            spec = {
                {
                    mode = { "n", "x" },
                    { "<leader>q", group = "Quit", icon = "󰗼" },
                    { "<leader>b", group = "Buffer", icon = "󰈔" },
                    { "<leader>c", group = "Code", icon = "󰅩" },
                    { "<leader>d", group = "Debug", icon = "󰃤" },
                    { "<leader>e", group = "Oil", icon = "󰙅" },
                    { "<leader>s", group = "Search", icon = "󰈞" },

                    -- Test
                    { "<leader>t", group = "Test", icon = "󰙨" },
                    { "<leader>tt", group = "Test Summary", icon = "󰙨" },

                    -- { "<leader>y", group = "Yazi", icon = "󰇥" },
                    -- { "<leader>x", group = "Trouble", icon = "" },

                    { "gx", desc = "Open with system app" },

                    -- Git
                    { "<leader>g", group = "Git", icon = "" },
                    { "<leader>gh", group = "Hunks" },
                    { "<leader>gg", group = "Lazygit" },

                    -- Surround
                    { "s", group = "Surround", icon = "󰅪" },
                    { "sa", desc = "Add surround" },
                    { "sd", desc = "Delete surround" },
                    { "sr", desc = "Replace surround" },

                    -- Hidden Keys
                    { "<C-w>h", hidden = true },
                    { "<C-w>j", hidden = true },
                    { "<C-w>k", hidden = true },
                    { "<C-w>l", hidden = true },
                    { "gt", hidden = true },
                    { "gT", hidden = true },
                    { "]B", hidden = true },
                    { "[B", hidden = true },
                },
            },
        },
        keys = {},
    },
}
