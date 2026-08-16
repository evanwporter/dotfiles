return {
    {
        "dmtrKovalenko/fff",
        cond = not vim.g.vscode,
        build = function()
            -- downloads a prebuilt binary or falls back to cargo build
            require("fff.download").download_or_build_binary()
        end,

        commit = "63fac0b45534be1645c9f23713963e45172dc89b",

        keys = {
            {
                "<leader><leader>",
                function()
                    require("fff").find_files()
                end,
                desc = "Find files",
            },
        },

        init = function()
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

        opts = {
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
        },

        config = function(_, opts)
            require("fff").setup(opts)
        end,
    },
}
