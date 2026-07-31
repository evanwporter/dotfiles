-- grug-far - Search and replace across files
-- Installation handled by lua/sources.lua

return {
    "grug-far.nvim",
    lazy = true,
    keys = {
        {
            "<leader>sr",
            function()
                local grug = require("grug-far")
                local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                grug.open({
                    transient = true,
                    prefills = {
                        filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                    },
                })
            end,
            mode = { "n", "x" },
            desc = "Search and Replace",
        },
        {
            "<leader>sR",
            function()
                require("grug-far").open({
                    transient = true,
                    prefills = {
                        paths = vim.fn.expand("%"),
                    },
                })
            end,
            desc = "Find and Replace in File",
            mode = { "n", "x" },
        },
    },
    after = function()
        require("grug-far").setup({
            openTargetWindow = {
                preferredLocation = "right",
                exclude = {
                    "dashboard",
                },
            },
        })

        -- Tab navigation in grug-far buffer
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "grug-far",
            callback = function(event)
                vim.keymap.set("i", "<Tab>", function()
                    local instance = require("grug-far").get_instance(event.buf)

                    if instance then
                        instance:goto_next_input()
                    end
                end, {
                    buffer = event.buf,
                    silent = true,
                    desc = "Grug Far: Next input",
                })

                vim.keymap.set("i", "<S-Tab>", function()
                    local instance = require("grug-far").get_instance(event.buf)

                    if instance then
                        instance:goto_prev_input()
                    end
                end, {
                    buffer = event.buf,
                    silent = true,
                    desc = "Grug Far: Previous input",
                })
            end,
        })
    end,
}
