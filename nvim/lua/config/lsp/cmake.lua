-- CMake LSP configuration
vim.lsp.config("neocmake", {
    cmd = {
        "neocmakelsp",
        "stdio",
    },
    filetypes = {
        "cmake",
    },
    root_markers = {
        "CMakePresets.json",
        "CTestConfig.cmake",
        ".git",
    },
    init_options = {
        buildDirectory = "build",
    },
})
vim.lsp.enable("neocmake")
