return {
  { "mason-org/mason.nvim", opts = {} },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "alejandra",
        "bash-language-server",
        "clangd",
        "cmake-language-server",
        "cmakelang",
        "cmakelint",
        "codelldb",
        "fish-lsp",
        "js-debug-adapter",
        "json-lsp",
        "lua-language-server",
        "markdown-toc",
        "markdownlint-cli2",
        "marksman",
        "neocmakelsp",
        "nil",
        "prettier",
        "ruff",
        "rust-analyzer",
        "stylua",
        "taplo",
        "tree-sitter-cli",
        "verible",
        "vtsls",
        "yaml-language-server",
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = true,
    },
  },

  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--query-driver=/run/current-system/sw/bin/clang++,/run/current-system/sw/bin/g++,/nix/store/*/bin/clang++,/nix/store/*/bin/g++",
          },
        },
      },
    },

    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end,
  },
}
