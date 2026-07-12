return {
    {
        "mikavilpas/yazi.nvim",
        version = "*",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        keys = {
            --in this section, choose your own keymappings!
            {
                "<leader>y",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Yazi",
            },
            -- {
            --   -- Open in the current working directory
            --   "<leader>",
            --   "<cmd>Yazi cwd<cr>",
            --   desc = "Open the file manager in nvim's working directory",
            -- },
            {
                "<c-up>",
                "<cmd>Yazi toggle<cr>",
                desc = "Resume the last yazi session",
            },
        },
        opts = {
            open_for_directories = false,
            keymaps = {
                show_help = "<f1>",
            },

            -- Make full screen
            floating_window_scaling_factor = 1,
            yazi_floating_window_border = "none",
            yazi_floating_window_zindex = 999,
        },
        -- if you use `open_for_directories=true`, this is recommended
        -- init = function()
        --   -- mark netrw as loaded so it's not loaded at all.
        --   --
        --   -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        --   vim.g.loaded_netrwPlugin = 1
        -- end,
    },
}
