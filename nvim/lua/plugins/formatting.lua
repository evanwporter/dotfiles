return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        verilog = { "verible" },
        systemverilog = { "verible" },

        python = {
          "ruff_fix",
          "ruff_format",
          "ruff_organize_imports",
        },

        json = { "prettier" },
        jsonc = { "prettier" },
        json5 = { "prettier" },
      },
    },
  },
}
