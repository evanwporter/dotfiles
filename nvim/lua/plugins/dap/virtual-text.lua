-- nvim-dap-virtual-text - Show virtual text for current frame
-- Installation handled by lua/sources.lua

return {
    "nvim-dap-virtual-text",
    lazy = true,
    keys = {
        { "<leader>db", desc = "Toggle Breakpoint" },
    },
    after = function()
        require("nvim-dap-virtual-text").setup({})
    end,
}
