return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd-22",
            "--clang-tidy",
            -- "--compile-commands-dir=./",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
          },
        },
      },
    },
  },
}

