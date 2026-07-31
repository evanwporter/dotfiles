-- C/C++ LSP configuration
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--query-driver=/run/current-system/sw/bin/clang++,/run/current-system/sw/bin/g++,/nix/store/*/bin/clang++,/nix/store/*/bin/g++",
    },
})
vim.lsp.enable("clangd")
