return {
    {
        "ThePrimeagen/harpoon",
        enabled = true,
        branch = "harpoon2",
        opts = {
            menu = {
                width = vim.api.nvim_win_get_width(0) - 4,
            },
            settings = {
                save_on_toggle = true,
            },
        },
        keys = function()
            local keys = {
                {
                    "<leader>h",
                    function()
                        require("harpoon"):list():add()
                    end,
                    desc = "Harpoon",
                },
                {
                    "<leader>H",
                    function()
                        local harpoon = require("harpoon")
                        harpoon.ui:toggle_quick_menu(harpoon:list())
                    end,
                    desc = "Harpoon Menu",
                },
            }

            return keys
        end,
        config = function(_, opts)
            local harpoon = require("harpoon")
            harpoon:setup(opts)

            -- Which-key discovers these mappings automatically. Only create a
            -- mapping when its Harpoon slot is populated.
            local function update_whichkey_harpoon()
                local items = harpoon:list().items

                for i = 1, 9 do
                    local key = "<leader>" .. i
                    local item = items[i]

                    if item and item.value ~= "" then
                        local index = i
                        local filename = vim.fs.basename(item.value)
                        vim.keymap.set("n", key, function()
                            harpoon:list():select(index)
                        end, { desc = "harpoon_icon " .. filename })
                    else
                        pcall(vim.keymap.del, "n", key)
                    end
                end
            end

            -- Harpoon 2 extension callbacks use their event names directly.
            harpoon:extend({
                ADD = update_whichkey_harpoon,
                REMOVE = update_whichkey_harpoon,
                REPLACE = update_whichkey_harpoon,
                LIST_CHANGE = update_whichkey_harpoon,
            })

            -- Initialize on startup
            update_whichkey_harpoon()
        end,
    },
}
