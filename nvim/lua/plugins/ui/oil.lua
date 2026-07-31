return {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    opts = {
        skip_confirm_for_simple_edits = true,
        columns = {
            "icon",
        },
        keymaps = {
            ["<CR>"] = "actions.select",
            ["q"] = {
                callback = function()
                    require("oil").close()
                    -- Check if we should show dashboard after closing Oil
                    vim.schedule(function()
                        local has_real_buffers = false
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                            if
                                vim.api.nvim_buf_is_valid(buf)
                                and vim.bo[buf].buflisted
                                and vim.bo[buf].buftype == ""
                                and vim.bo[buf].filetype ~= "dashboard"
                                and vim.api.nvim_buf_get_name(buf) ~= ""
                            then
                                has_real_buffers = true
                                break
                            end
                        end

                        if not has_real_buffers then
                            vim.cmd("enew")
                        end
                    end)
                end,
                desc = "Close Oil",
            },
        },
    },
    keys = {
        {
            "<leader>e",
            function()
                if vim.bo.filetype == "oil" then
                    vim.cmd("bd")
                    vim.schedule(function()
                        local has_real_buffers = false
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                            if
                                vim.api.nvim_buf_is_valid(buf)
                                and vim.bo[buf].buflisted
                                and vim.bo[buf].buftype == ""
                                and vim.bo[buf].filetype ~= "dashboard"
                                and vim.api.nvim_buf_get_name(buf) ~= ""
                            then
                                has_real_buffers = true
                                break
                            end
                        end

                        if not has_real_buffers then
                            vim.cmd("enew")
                        end
                    end)
                else
                    require("oil").open()
                end
            end,
            desc = "Toggle Oil",
        },
        {
            "<leader>E",
            function()
                require("fzf-lua").fzf_exec("fd --type d", {
                    prompt = "Directories> ",
                    actions = {
                        ["default"] = function(selected)
                            if selected and #selected > 0 then
                                require("oil").open(selected[1])
                            end
                        end,
                    },
                })
            end,
            desc = "Directory Search",
        },
    },
}
