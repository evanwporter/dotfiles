-- fzf-lua configuration
-- Installation handled by lua/sources.lua

local selection = require("util.selection")

return {
    "fzf-lua",
    lazy = true,
    keys = {
        {
            "<leader>bb",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "Find buffers",
        },
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
        { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },

        -- LSP (desc-only keymaps for which-key)
        { "gr", desc = "Go to References" },
        { "<leader>sd", desc = "Search Document Symbols" },
        { "<leader>sD", desc = "Search Workspace Symbols" },
        { "<leader>cx", desc = "Diagnostics Document" },
        { "<leader>cX", desc = "Diagnostics Workspace" },
        { "gai", desc = "LSP Incoming Calls" },
        { "gao", desc = "LSP Outgoing Calls" },

        -- Git
        { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff (files)" },
        { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
        { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
        -- { "<leader>E", desc = "Directory Explorer" }
    },
    before = function()
        -- Hijack vim.ui.select to lazy-load fzf-lua when needed
        local original_ui_select = vim.ui.select
        vim.ui.select = function(...)
            -- Restore original first
            vim.ui.select = original_ui_select
            -- Load fzf-lua
            require("lz.n").trigger_load("fzf-lua")
            -- Call vim.ui.select again (now with fzf registered)
            return vim.ui.select(...)
        end
    end,
    after = function()
        local fzf = require("fzf-lua")

        local ui_select_opts = function(fzf_opts, items)
            local prompt = vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", ""))

            return vim.tbl_deep_extend("force", fzf_opts, {
                prompt = " ",
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
        end

        fzf.setup({
            fzf_opts = {
                ["--layout"] = "default",
            },
            ui_select = ui_select_opts,
        })

        -- Register as vim.ui.select provider
        fzf.register_ui_select(ui_select_opts)

        -- Additional keymaps set after plugin loads
        vim.keymap.set("n", "<leader>ss", fzf.resume, {
            desc = "Resume Fzf search",
        })
    end,
}
