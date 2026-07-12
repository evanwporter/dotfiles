require("util.lsp").add_servers({
    slang_server = {
        name = "slang-server",
        cmd = {
            vim.fn.expand("~/slang-server/build/debug/bin/slang-server"),
        },
        filetypes = {
            "systemverilog",
            "verilog",
        },
        single_file_support = true,
    },
})

return {}
