vim.lsp.config("slang_server", {
    cmd = { vim.fn.expand("~/slang-server/build/debug/bin/slang-server") },
    filetypes = { "systemverilog", "verilog" },
    root_markers = { ".git", ".slang" },
})

vim.lsp.enable("slang_server")
