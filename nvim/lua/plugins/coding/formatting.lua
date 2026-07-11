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

        lua = { "stylua" },

        json = { "prettier" },
        jsonc = { "prettier" },
        json5 = { "prettier" },
        yaml = { "prettier" },

        nix = { "alejandra" },
        cmake = { "cmake_format" },
      },

      formatters = {
        alejandra = {
          command = "alejandra",
          args = {
            "--experimental-config",
            vim.fn.expand("~/.config/alejandra/alejandra.toml"),
          },
        },
      },

      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
  },
}
