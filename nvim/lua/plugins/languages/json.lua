require("util.lsp").add_servers({
    jsonls = {
        settings = {
            -- json = {
            --     schemas = require("schemastore").json.schemas(),
            --     validate = { enable = true },
            -- },
        },
    },
})

return {
    -- {
    --     "b0o/schemastore.nvim",
    --     lazy = true,
    -- },
}
