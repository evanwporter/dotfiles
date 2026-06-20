return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        slang_server = {
          name = "slang-server",
          mason = false,
          cmd = { vim.fn.expand("~/slang-server/build/debug/bin/slang-server") },
          filetypes = { "systemverilog", "verilog", "slang" },
          single_file_support = true,
        },
      },
    },
  },
  {
    -- "hudson-trading/slang-server.nvim",
    dir = vim.fn.expand("~/slang-server/clients/neovim/"),
    name = "slang-server.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    ft = {
      "verilog",
      "systemverilog",
    },
    opts = {},
  },
}
