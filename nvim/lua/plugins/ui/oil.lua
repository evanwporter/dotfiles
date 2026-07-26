return {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    opts = {
        skip_confirm_for_simple_edits = true,
        columns = {
            "icon",
        },
        keymaps = {
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
                require("oil").open()
            end,
            desc = "Oil",
        },
        {
            "<leader>E",
            function()
                require("oil").open(vim.uv.cwd())
            end,
            desc = "Oil (root dir)",
        },
    },
}
