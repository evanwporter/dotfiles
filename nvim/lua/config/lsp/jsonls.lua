vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    once = true,
    callback = function()
        vim.lsp.config("jsonls", {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        })
        vim.lsp.enable("jsonls")
    end,
})
