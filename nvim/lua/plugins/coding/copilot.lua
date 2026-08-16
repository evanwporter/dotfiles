return {
    {
        {
            "zbirenbaum/copilot.lua",
            cond = not vim.g.vscode,
            cmd = "Copilot",
            build = ":Copilot auth",
            event = "BufReadPost",
            opts = {
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    hide_during_completion = true,
                    keymap = {
                        -- Blink handles menu completions; this accepts
                        -- standalone Copilot ghost text.
                        accept = "<Tab>",
                        next = "<M-]>",
                        prev = "<M-[>",
                    },
                },
                panel = { enabled = false },
                filetypes = {
                    markdown = true,
                    help = true,
                },
            },
        },
    },
}
