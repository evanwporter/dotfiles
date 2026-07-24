require("util.lsp").add_servers({
    yamlls = {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server", "--stdio" },
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
