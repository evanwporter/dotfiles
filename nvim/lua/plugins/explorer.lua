return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,

    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "nvim-mini/mini.icons",
        opts = {},
        init = function()
          package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
          end
        end,
      },
    },

    keys = {
      {
        "<leader>e",
        function()
          vim.cmd("Neotree toggle filesystem left dir=" .. vim.fn.getcwd())
        end,
        desc = "Explorer",
      },
    },

    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",

      enable_git_status = true,
      enable_diagnostics = true,

      sources = {
        "filesystem",
        "buffers",
        -- "git_status",
      },

      source_selector = {
        winbar = true,
        statusline = false,

        sources = {
          {
            source = "filesystem",
            display_name = " 󰉓 Files ",
          },
          {
            source = "buffers",
            display_name = " 󰈚 Buffers ",
          },
          -- {
          --   source = "git_status",
          --   display_name = " 󰊢 Git ",
          -- },
        },
      },

      filesystem = {
        follow_current_file = {
          enabled = true,
        },

        use_libuv_file_watcher = true,

        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
          },
          never_show = {
            ".git",
            ".DS_Store",
          },
        },
      },

      buffers = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
        group_empty_dirs = true,
        show_unloaded = true,

        filter = function(bufnr)
          return vim.bo[bufnr].buftype ~= "terminal"
        end,
      },

      window = {
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
          ["a"] = {
            "add",
            config = {
              show_path = "relative",
            },
          },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
          ["R"] = "refresh",
        },
      },
    },
  },
}
