vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim", "mnw" },
            },
            workspace = {
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
            completion = {
                callSnippet = "Disable",
                keywordSnippet = "Disable",
            },
        },
    },
})
vim.lsp.enable("lua_ls")
