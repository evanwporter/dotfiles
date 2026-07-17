return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = true,
        event = "BufReadPost",

        init = function()
            vim.g.no_plugin_maps = true
        end,

        config = function()
            -- require("nvim-treesitter-textobjects").setup({
            --   select = {
            --     lookahead = true,
            --     selection_modes = {
            --       ["@parameter.inner"] = "v",
            --       ["@parameter.outer"] = "v",
            --       ["@function.inner"] = "V",
            --       ["@function.outer"] = "V",
            --       ["@comment.outer"] = "V",
            --     },
            --     include_surrounding_whitespace = false,
            --   },
            --
            --   move = {
            --     set_jumps = true,
            --   },
            -- })

            local select = require("nvim-treesitter-textobjects.select")

            vim.keymap.set({ "x", "o" }, "af", function()
                select.select_textobject("@function.outer", "textobjects")
            end, {
                silent = true,
                desc = "Around function",
            })

            vim.keymap.set({ "x", "o" }, "if", function()
                select.select_textobject("@function.inner", "textobjects")
            end, {
                silent = true,
                desc = "Inside function",
            })

            -- Use aa/ia for arguments so ap/ip retain paragraph behavior.
            vim.keymap.set({ "x", "o" }, "aa", function()
                select.select_textobject("@parameter.outer", "textobjects")
            end, {
                silent = true,
                desc = "Around argument",
            })

            vim.keymap.set({ "x", "o" }, "ia", function()
                select.select_textobject("@parameter.inner", "textobjects")
            end, {
                silent = true,
                desc = "Inside argument",
            })

            vim.keymap.set({ "x", "o" }, "ac", function()
                select.select_textobject("@comment.outer", "textobjects")
            end, {
                silent = true,
                desc = "Around comment",
            })
        end,
    },
}
