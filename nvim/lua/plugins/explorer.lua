return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,

    dependencies = {
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
          require("nvim-tree.api").tree.toggle({
            path = vim.fn.getcwd(),
            focus = true,
          })
        end,
        desc = "Explorer",
      },
    },

    opts = {
      disable_netrw = true,
      hijack_netrw = true,

      sync_root_with_cwd = true,
      respect_buf_cwd = true,

      view = {
        side = "left",
        width = 32,
      },

      renderer = {
        group_empty = true,
        icons = {
          git_placement = "right_align",

          glyphs = {
            git = {
              unstaged = "●",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },

          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },

      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = {
          "^\\.git$",
          "^\\.DS_Store$",
        },
        exclude = {},
      },

      git = {
        enable = true,
        ignore = false,
      },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },

      update_focused_file = {
        enable = true,
        update_root = false,
      },

      filesystem_watchers = {
        enable = true,
      },

      actions = {
        open_file = {
          quit_on_open = false,
        },
      },

      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "<space>", "<Nop>", opts("Disable Space"))
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
      end,
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    enabled = false,

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
