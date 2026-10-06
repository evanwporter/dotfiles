vim.lsp.config("texlab", {
    settings = {
        texlab = {
            build = {
                executable = "latexmk",
                args = {
                    "-pdf",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "%f",
                },
                onSave = false,
            },

            forwardSearch = {
                executable = "zathura",
                args = {
                    "--synctex-forward",
                    "%l:1:%f",
                    "%p",
                },
            },
        },
    },
})

vim.lsp.enable("texlab")
