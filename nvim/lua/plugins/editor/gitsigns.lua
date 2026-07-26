return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },

        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
        },
        keys = {
            {
                "]h",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        require("gitsigns").nav_hunk("next")
                    end
                end,
                desc = "Next Hunk",
            },
            {
                "[h",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        require("gitsigns").nav_hunk("prev")
                    end
                end,
                desc = "Prev Hunk",
            },
            {
                "<leader>ghd",
                function()
                    require("gitsigns").diffthis()
                end,
                desc = "Diff This",
            },
            {
                "<leader>ghD",
                function()
                    require("gitsigns").diffthis("~")
                end,
                desc = "Diff This ~",
            },
        },
    },
}
