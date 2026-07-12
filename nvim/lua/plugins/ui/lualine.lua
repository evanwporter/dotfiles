return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.options = opts.options or {}
            opts.options.disabled_filetypes = opts.options.disabled_filetypes or {}

            vim.o.showtabline = 0
            opts.tabline = {}
            opts.options.globalstatus = true

            local function is_normal_file_buffer()
                local ft = vim.bo.filetype
                local bt = vim.bo.buftype

                if bt ~= "" then
                    return false
                end

                if ft:match("^snacks") then
                    return false
                end

                return not vim.tbl_contains({
                    "neo-tree",
                    "NvimTree",
                    "oil",
                    "Trouble",
                    "lazy",
                    "dap-repl",
                    "dapui_scopes",
                    "dapui_breakpoints",
                    "dapui_stacks",
                    "dapui_watches",
                    "dapui_console",
                }, ft)
            end

            local buffer_winbar = {
                lualine_a = {
                    {
                        "buffers",
                        mode = 0,
                        show_filename_only = true,
                        show_modified_status = true,
                        cond = is_normal_file_buffer,
                    },
                },
            }

            opts.winbar = buffer_winbar
            opts.inactive_winbar = buffer_winbar

            opts.options.disabled_filetypes = vim.tbl_deep_extend("force", opts.options.disabled_filetypes, {
                winbar = {
                    "neo-tree",
                    "NvimTree",
                    "oil",
                    "Trouble",
                    "lazy",
                    "snacks_picker",
                    "snacks_picker_input",
                    "snacks_picker_list",
                    "snacks_picker_preview",
                    "snacks_dashboard",
                    "snacks_terminal",
                    "dap-repl",
                    "dapui_scopes",
                    "dapui_breakpoints",
                    "dapui_stacks",
                    "dapui_watches",
                    "dapui_console",
                },
            })
        end,
    },
}
