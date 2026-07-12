local selection = require("util.selection")

return {
    {
        "ibhagwan/fzf-lua",
        keys = {
            {
                "<leader>bb",
                function()
                    require("fzf-lua").buffers()
                end,
                desc = "Find buffers",
            },
            -- {
            --   "grr",
            --   function()
            --     require("fzf-lua").lsp_references()
            --   end,
            --   desc = "LSP references",
            -- },
            {
                "<leader>sg",
                function()
                    require("fzf-lua").live_grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>sg",
                function()
                    require("fzf-lua").live_grep({ search = selection.get_visual_selection() })
                end,
                mode = "x",
                desc = "Grep Selection",
            },
            {
                "<leader>sw",
                function()
                    require("fzf-lua").grep_cword()
                end,
                desc = "Search Word Under Cursor",
            },
            { "gr", desc = "Go to References" },
            { "<leader>sd", desc = "Search Document Symbols" },
            { "<leader>sD", desc = "Search Workspace Symbols" },
            { "<leader>cx", desc = "Diagnostics Document" },
            { "<leader>cX", desc = "Diagnostics Workspace" },
            { "gai", desc = "LSP Incoming Calls" },
            { "gao", desc = "LSP Outgoing Calls" },
        },
        opts = {
            fzf_opts = {
                ["--layout"] = "default",
            },
            ui_select = function(fzf_opts, items)
                local prompt = vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", ""))

                return vim.tbl_deep_extend("force", fzf_opts, {
                    prompt = " ",
                    fzf_opts = {
                        ["--layout"] = "reverse-list",
                    },
                    winopts = {
                        title = " " .. prompt .. " ",
                        title_pos = "center",
                        width = 0.35,
                        height = math.floor(math.min(vim.o.lines * 0.6, #items + 4) + 0.5),
                    },
                })
            end,
        },
        config = function(_, opts)
            local fzf = require("fzf-lua")
            fzf.setup(opts)

            vim.keymap.set("n", "<leader>ss", fzf.resume, {
                desc = "Resume Fzf search",
            })
        end,
        init = function()
            local original_select = vim.ui.select

            vim.ui.select = function(...)
                require("lazy").load({
                    plugins = { "fzf-lua" },
                })

                -- fzf-lua's setup should have replaced vim.ui.select.
                if vim.ui.select == original_select then
                    return original_select(...)
                end

                local ret = vim.ui.select(...)

                vim.defer_fn(function()
                    pcall(vim.cmd, "startinsert")
                end, 10)

                return ret
            end
        end,
    },
}
