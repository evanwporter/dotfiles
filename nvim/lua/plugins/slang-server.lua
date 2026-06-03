return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        slang_server = {
          mason = false,
          cmd = { "/home/evanw/slang-server/build/clang-debug/bin/slang-server" },
          filetypes = { "systemverilog", "verilog", "slang" },
          single_file_support = true,
        },
      },
    },
  },
  {
    "hudson-trading/slang-server.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
  },
}
