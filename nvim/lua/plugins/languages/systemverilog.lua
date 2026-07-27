vim.lsp.config("slang_server", {
    name = "slang-server",
    cmd = {
        vim.fn.expand("~/slang-server/build/debug/bin/slang-server"),
    },
    filetypes = {
        "systemverilog",
        "verilog",
    },
    single_file_support = true,
})
vim.lsp.enable("slang_server")

return {}
