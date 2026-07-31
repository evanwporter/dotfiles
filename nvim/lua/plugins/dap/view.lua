-- nvim-dap-view - Minimalist debug interface
-- Installation handled by lua/sources.lua

return {
    "nvim-dap-view",
    lazy = true,
    keys = {
        { "<leader>dd", function() require("dap-view").toggle(true) end, desc = "Dap View" },
        { "<leader>de", function() require("dap-view").hover(nil, true) end, desc = "Eval", mode = { "n", "x" } },
    },
    before = function()
        -- Ensure nvim-dap is loaded before dap-view
        require("lz.n").trigger_load("nvim-dap")
    end,
    after = function()
        local dap = require("dap")
        local dapview = require("dap-view")

        dapview.setup({
            windows = {
                size = 0.25,
                position = "right",
                terminal = {
                    size = 0.5,
                    position = "left",
                    hide = {},
                },
            },
            winbar = {
                show = true,
                sections = {
                    "watches",
                    "scopes",
                    "exceptions",
                    "breakpoints",
                    "repl",
                },
                default_section = "scopes",
                show_keymap_hints = false,
                controls = {
                    enabled = true,
                    position = "right",
                },
            },
        })

        dap.listeners.after.event_initialized["dap_view_config"] = function()
            dapview.open()
        end
    end,
}
