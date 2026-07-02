return {
  {
    "zbirenbaum/copilot.lua",
    -- enabled = false,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
      },
      panel = {
        enabled = false,
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "fang2hou/blink-copilot",
    },
    branch = "v1",
    opts = {
      snippets = {
        preset = "default",
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "copilot",
        },

        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },

      keymap = {
        preset = "super-tab",

        -- ["<Tab>"] = {
        --   function(cmp)
        --     if cmp.is_visible() then
        --       return cmp.accept()
        --     end
        --   end,
        --   "snippet_forward",
        --   "fallback",
        -- },

        -- ["<S-Tab>"] = {
        --   "snippet_backward",
        --   function(cmp)
        --     if cmp.is_visible() then
        --       return cmp.select_prev()
        --     end
        --   end,
        --   "fallback",
        -- },
        --
        --
        -- ["<Down>"] = { "select_next", "fallback" },
        -- ["<Up>"] = { "select_prev", "fallback" },
        --
        -- ["<C-n>"] = { "select_next", "fallback" },
        -- ["<C-p>"] = { "select_prev", "fallback" },
        -- ["<C-e>"] = { "hide", "fallback" },
        --
        -- ["<CR>"] = { "fallback" },
      },

      cmdline = {
        enabled = true,

        keymap = {
          preset = "cmdline",

          ["<Right>"] = false,
          ["<Left>"] = false,

          ["<Down>"] = { "select_next", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },

          ["<CR>"] = { "accept_and_enter", "fallback" },
          ["<C-y>"] = { "accept", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
        },

        completion = {
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },

          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
            end,
          },
        },
      },
    },
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {},
    enabled = false,
  },
}
