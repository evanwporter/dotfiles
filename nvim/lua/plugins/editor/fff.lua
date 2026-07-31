-- fff - Fast file finder with preview
-- Installation handled by lua/sources.lua

return {
    "fff",
    lazy = true,
    keys = {
        {
            "<leader><leader>",
            function()
                require("fff").find_files()
            end,
            desc = "Find files",
        },
    },
    before = function()
        -- Set up highlights before plugin loads (init equivalent)
        local function set_fff_highlights()
            vim.api.nvim_set_hl(0, "FFFCursorLine", {
                bg = "#504945",
            })
        end

        set_fff_highlights()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = set_fff_highlights,
        })
    end,
    after = function()
        -- Setup plugin (config equivalent with opts)
        require("fff").setup({
            prompt = " ",

            hl = {
                cursor = "FFFCursorLine",
            },

            debug = {
                enabled = false,
                show_scores = false,
            },

            preview = {
                enabled = true,
                cursorlineopt = "both",
            },
        })
    end,
}
