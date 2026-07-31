-- hardtime.nvim - Break bad vim habits
-- Installation handled by lua/sources.lua

return {
    "hardtime.nvim",
    lazy = true,
    event = "DeferredUIEnter",
    before = function()
        -- Load nui.nvim dependency
        require("lz.n").trigger_load("nui.nvim")
    end,
    after = function()
        require("hardtime").setup({
            disabled_keys = {
                ["<Left>"] = false,
                ["<Right>"] = false,
            },
            -- disable_mouse = false,
        })
    end,
}
