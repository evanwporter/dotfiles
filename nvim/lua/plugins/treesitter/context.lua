-- nvim-treesitter-context - Show code context
-- Installation handled by lua/sources.lua

return {
    "nvim-treesitter-context",
    lazy = true,
    cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
    beforeAll = function()
        -- Setup keymaps before plugin loads
        vim.keymap.set({ "n" }, "[C", function()
            require("treesitter-context").go_to_context(vim.v.count1)
        end, { silent = true, desc = "Goto treesitter context" })

        vim.keymap.set({ "n" }, "]C", function()
            require("treesitter-context").toggle()
        end, { silent = true, desc = "Toggle treesitter context" })
    end,
    after = function()
        require("treesitter-context").setup({
            enable = true,
        })
    end,
}
