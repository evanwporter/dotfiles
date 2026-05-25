return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd-22",
            "--clang-tidy",
            "--compile-commands-dir=build/debug",
            "--completion-style=detailed",
            "--header-insertion=iwyu"
          },
        },
      },
    },
  },
}