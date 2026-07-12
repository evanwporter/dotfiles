require("util.lsp").add_servers({
    yaml_language_server = {
        -- Have to add this for yamlls to understand that we support line folding
        capabilities = {
            textDocument = {
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        },
        settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
                keyOrdering = false,
                format = {
                    enable = false,
                },
                validate = true,
            },
        },
    },
})

return {}
