return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = true,
        event = "BufReadPost",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    selection_modes = {
                        ["@parameter.inner"] = "v",
                        ["@parameter.outer"] = "v",
                        ["@function.inner"] = "V",
                        ["@function.outer"] = "V",
                        ["@class.inner"] = "V",
                        ["@class.outer"] = "V",
                        ["@scope"] = "v",
                    },
                },
                move = { set_jumps = true },
            })

            -- -------------
            -- Select Object
            -- -------------
            local ts_sel = require("nvim-treesitter-textobjects.select")

            -- Functions
            vim.keymap.set({ "x", "o" }, "af", function()
                ts_sel.select_textobject("@function.outer", "textobjects")
            end, { desc = "Around function" })
            vim.keymap.set({ "x", "o" }, "if", function()
                ts_sel.select_textobject("@function.inner", "textobjects")
            end, { desc = "Inside function" })

            -- Parameters
            vim.keymap.set({ "x", "o" }, "ap", function()
                ts_sel.select_textobject("@parameter.outer", "textobjects")
            end, { desc = "Around parameter" })
            vim.keymap.set({ "x", "o" }, "ip", function()
                ts_sel.select_textobject("@parameter.inner", "textobjects")
            end, { desc = "Inside parameter" })

            -- Conditionals
            vim.keymap.set({ "x", "o" }, "ac", function()
                ts_sel.select_textobject("@conditional.outer", "textobjects")
            end, { desc = "Around conditional" })
            vim.keymap.set({ "x", "o" }, "ic", function()
                ts_sel.select_textobject("@conditional.inner", "textobjects")
            end, { desc = "Inside conditional" })

            -- Loops
            vim.keymap.set({ "x", "o" }, "al", function()
                ts_sel.select_textobject("@loop.outer", "textobjects")
            end, { desc = "Around loop" })
            vim.keymap.set({ "x", "o" }, "il", function()
                ts_sel.select_textobject("@loop.inner", "textobjects")
            end, { desc = "Inside loop" })

            -- Classes
            vim.keymap.set({ "x", "o" }, "aC", function()
                ts_sel.select_textobject("@class.outer", "textobjects")
            end, { desc = "Around class" })
            vim.keymap.set({ "x", "o" }, "iC", function()
                ts_sel.select_textobject("@class.inner", "textobjects")
            end, { desc = "Inside class" })

            -- Block
            vim.keymap.set({ "x", "o" }, "ao", function()
                ts_sel.select_textobject("@block.outer", "textobjects")
            end, { desc = "Around block" })
            vim.keymap.set({ "x", "o" }, "io", function()
                ts_sel.select_textobject("@block.inner", "textobjects")
            end, { desc = "Inside block" })

            -- -----------
            -- Move Object
            -- -----------
            local ts_move = require("nvim-treesitter-textobjects.move")

            -- Function boundaries
            vim.keymap.set({ "n", "x", "o" }, "]f", function()
                ts_move.goto_next("@function.outer", "textobjects")
            end, { desc = "Next function boundary" })
            vim.keymap.set({ "n", "x", "o" }, "[f", function()
                ts_move.goto_previous("@function.outer", "textobjects")
            end, { desc = "Previous function boundary" })

            -- Function starts
            vim.keymap.set({ "n", "x", "o" }, "]F", function()
                ts_move.goto_next_start("@function.outer", "textobjects")
            end, { desc = "Next function start" })
            vim.keymap.set({ "n", "x", "o" }, "[F", function()
                ts_move.goto_previous_start("@function.outer", "textobjects")
            end, { desc = "Previous function start" })

            -- Parameters
            vim.keymap.set({ "n", "x", "o" }, "]p", function()
                ts_move.goto_next_start("@parameter.inner", "textobjects")
            end, { desc = "Next parameter" })
            vim.keymap.set({ "n", "x", "o" }, "[p", function()
                ts_move.goto_previous_start("@parameter.inner", "textobjects")
            end, { desc = "Previous parameter" })

            -- Conditional
            vim.keymap.set({ "n", "x", "o" }, "]c", function()
                ts_move.goto_next_start("@conditional.outer", "textobjects")
            end, { desc = "Next conditional" })
            vim.keymap.set({ "n", "x", "o" }, "[c", function()
                ts_move.goto_previous_start("@conditional.outer", "textobjects")
            end, { desc = "Previous conditional" })

            -- Loop
            vim.keymap.set({ "n", "x", "o" }, "]r", function()
                ts_move.goto_next_start("@loop.outer", "textobjects")
            end, { desc = "Next loop" })
            vim.keymap.set({ "n", "x", "o" }, "[r", function()
                ts_move.goto_previous_start("@loop.outer", "textobjects")
            end, { desc = "Previous loop" })

            -- Block
            vim.keymap.set({ "n", "x", "o" }, "]o", function()
                ts_move.goto_next_start("@block.outer", "textobjects")
            end, { desc = "Next block" })
            vim.keymap.set({ "n", "x", "o" }, "[o", function()
                ts_move.goto_previous_start("@block.outer", "textobjects")
            end, { desc = "Previous block" })
        end,
    },

    -- -------------------
    -- Tree-sitter Context
    -- -------------------
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
        keys = {
            {
                "[C",
                function()
                    require("treesitter-context").go_to_context(vim.v.count1)
                end,
                desc = "Goto treesitter context",
                silent = true,
            },
            {
                "]C",
                function()
                    require("treesitter-context").toggle()
                end,
                desc = "Toggle treesitter context",
                silent = true,
            },
        },
        opts = {
            enable = true,
        },
    },
}
