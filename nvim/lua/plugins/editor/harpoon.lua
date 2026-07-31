-- Harpoon - Quick file navigation
-- Installation handled by lua/sources.lua

local function ensure_harpoon()
    local harpoon = require("harpoon")

    -- Setup harpoon if not already done
    if not harpoon._setup_done then
        harpoon:setup({
            menu = {
                width = vim.api.nvim_win_get_width(0) - 4,
            },
            settings = {
                save_on_toggle = true,
            },
        })

        -- Setup number keymaps
        for i = 1, 9 do
            vim.keymap.set("n", "<leader>" .. i, function()
                require("harpoon"):list():select(i)
            end, { desc = "which_key_ignore" })
        end

        harpoon._setup_done = true
    end

    return harpoon
end

return {
    "harpoon",
    lazy = true,
    before = function()
        -- Load plenary dependency first
        require("lz.n").trigger_load("plenary.nvim")
    end,
    keys = {
        {
            "<leader>H",
            function()
                ensure_harpoon():list():add()
            end,
            desc = "Harpoon File",
        },
        {
            "<leader>h",
            function()
                local harpoon = ensure_harpoon()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Harpoon Quick Menu",
        },
    },
}
