-- which-key.nvim - Key binding helper
-- Installation handled by lua/sources.lua

return {
    "which-key.nvim",
    event = "DeferredUIEnter",
    beforeAll = function()
        -- Trigger mini.icons to load first (dependency)
        require("lz.n").trigger_load("mini.icons")
    end,
    after = function()
        require("which-key").setup({
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
                    { "<leader>s", group = "Find", icon = "󰈞" },
                    { "<leader>t", group = "Test", icon = "󰙨" },
                    { "<leader>tt", group = "Test Summary", icon = "󰙨" },
                    { "<leader>y", group = "Yazi", icon = "󰇥" },
                    { "<leader>x", group = "Trouble", icon = "" },
                    { "<leader>g", group = "Git", icon = "" },
                    { "<leader>gh", group = "Hunks" },
                    { "<leader>gg", group = "Lazygit" },

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
        })
    end,
}
