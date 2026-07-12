require("util.lsp").add_servers({
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
})

return {}
