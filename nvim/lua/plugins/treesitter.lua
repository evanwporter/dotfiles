return {
    -- {
    --   "nvim-treesitter/nvim-treesitter",
    --   lazy = false,
    --   build = ":TSUpdate",
    --   enabled = false,
    --
    --   opts = {
    --     -- ensure_installed = {
    --     --   "c",
    --     --   "cpp",
    --     --   "cmake",
    --     --   "json",
    --     --   "lua",
    --     --   "markdown",
    --     --   "python",
    --     --   "rust",
    --     --   "toml",
    --     --   "typescript",
    --     -- },
    --   },
    -- },
    {
        "romus204/tree-sitter-manager.nvim",
        -- enabled = false,
        lazy = false,
        dependencies = {},
        config = function()
            require("tree-sitter-manager").setup({
                assume_installed = {
                    "bash",
                    "c",
                    "cmake",
                    "cpp",
                    "json",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "nix",
                    "python",
                    "rust",
                    "toml",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
            })
        end,
    },

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
