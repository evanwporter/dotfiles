vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--query-driver=/run/current-system/sw/bin/clang++,/run/current-system/sw/bin/g++,/nix/store/*/bin/clang++,/nix/store/*/bin/g++,/nix/store/*devkitARM*/opt/devkitpro/devkitARM/bin/arm-none-eabi-*",
    },
    capabilities = {
        offsetEncoding = { "utf-16" },
    },
    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac", -- AutoTools
        "Makefile",
        "configure.ac",
        "configure.in",
        "config.h.in",
        "meson.build",
        "meson_options.txt",
        "build.ninja",
        ".git",
    },
})
vim.lsp.enable("clangd")

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.keymap.set(
            "n",
            "<localleader>s",
            "<cmd>ClangdSwitchSourceHeader<CR>",
            { buffer = true, desc = "Switch Source/Header" }
        )
    end,
})
