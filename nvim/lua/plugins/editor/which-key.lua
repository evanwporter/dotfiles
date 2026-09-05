return {
    {
        "folke/which-key.nvim",
        cond = not vim.g.vscode,
        dependencies = {
            "nvim-mini/mini.icons",
        },
        event = "VeryLazy",

        ---@module "which-key"
        ---@type wk.Config|{}
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            preset = "helix",
            delay = 100,
            icons = {
                rules = {
                    {
                        pattern = "harpoon_icon",
                        icon = "󰛢",
                        color = "azure",
                    },
                },
            },
            replace = {
                desc = {
                    { "^harpoon_icon%s+", "" },
                    { "<Plug>%(?(.*)%)?", "%1" },
                    { "^%+", "" },
                    { "<[cC]md>", "" },
                    { "<[cC][rR]>", "" },
                    { "<[sS]ilent>", "" },
                    { "^lua%s+", "" },
                    { "^call%s+", "" },
                    { "^:%s*", "" },
                },
            },
            triggers = {
                { "<auto>", mode = "nxso" },
                -- -- Single-letter builtins are excluded from automatic triggers.
                -- -- This trigger replaces Vim's normal-mode `s` with our menu prefix.
                -- { "s", mode = "n" },
            },
            spec = {
                {
                    mode = { "n", "x" },
                    { "<leader>q", group = "Quit", icon = "󰗼" },
                    { "<leader>b", group = "Buffer", icon = "󰈔" },
                    { "<leader>c", group = "Code", icon = "󰅩" },
                    { "<leader>d", group = "Debug", icon = "󰃤" },
                    { "<leader>e", group = "Oil", icon = "󰙅" },
                    { "<leader>s", group = "Search", icon = "󰈞" },
                    { "<leader>Q", group = "Sessions" },

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

                    -- -- Surround
                    -- { "s", group = "Surround", icon = "󰅪" },
                    -- { "sa", desc = "Add surround" },
                    -- { "sd", desc = "Delete surround" },
                    -- { "sr", desc = "Replace surround" },

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
