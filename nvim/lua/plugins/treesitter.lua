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
        config = function(_, opts)
            require("nvim-treesitter-textobjects").setup(opts)

            local select = require("nvim-treesitter-textobjects.select")

            local function textobject(lhs, query, desc)
                vim.keymap.set({ "x", "o" }, lhs, function()
                    select.select_textobject(query, "textobjects")
                end, {
                    silent = true,
                    desc = desc,
                })
            end

            textobject("af", "@function.outer", "Around function")
            textobject("if", "@function.inner", "Inside function")
            textobject("ac", "@conditional.outer", "Around conditional")
            textobject("ic", "@conditional.inner", "Inside conditional")
        end,
    },
}
