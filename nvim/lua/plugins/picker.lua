return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    enabled = false,

    keys = {
      {
        "<leader><leader>",
        function()
          require("fff").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fb",
        function()
          require("fff").buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep()
        end,
        desc = "Live grep",
      },
      {
        "fw",
        function()
          require("fff").live_grep_under_cursor()
        end,
        mode = { "n", "x" },
        desc = "Search current word / selection",
      },
    },

    init = function()
      local function set_fff_highlights()
        vim.api.nvim_set_hl(0, "FFFCursorLine", {
          bg = "#504945",
        })
      end

      set_fff_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_fff_highlights,
      })
    end,

    opts = {
      prompt = " ",

      hl = {
        cursor = "FFFCursorLine",
      },

      debug = {
        enabled = false,
        show_scores = false,
      },

      preview = {
        enabled = true,
        cursorlineopt = "both",
      },
    },

    config = function(_, opts)
      require("fff").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope-frecency.nvim",
    version = "^1.0.0",
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    keys = {
      -- Files by frecency
      {
        "<leader><leader>",
        function()
          require("telescope").extensions.frecency.frecency()
        end,
        desc = "Find files",
      },

      -- Buffers (MRU)
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true,
            ignore_current_buffer = true,
          })
        end,
        desc = "Buffers",
      },

      -- Live grep
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live grep",
      },

      -- Grep word / selection under cursor
      {
        "<leader>fw",
        function()
          local builtin = require("telescope.builtin")
          local mode = vim.api.nvim_get_mode().mode
          if mode == "v" or mode == "V" or mode == "\22" then
            -- visual selection
            local _, ls, cs = unpack(vim.fn.getpos("'<"))
            local _, le, ce = unpack(vim.fn.getpos("'>"))
            local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
            if #lines == 0 then
              builtin.live_grep()
              return
            end
            lines[#lines] = string.sub(lines[#lines], 1, ce)
            lines[1] = string.sub(lines[1], cs)
            local text = table.concat(lines, "\n")
            builtin.live_grep({ default_text = text })
          else
            -- normal mode: use <cword>
            builtin.live_grep({ default_text = vim.fn.expand("<cword>") })
          end
        end,
        mode = { "n", "x" },
        desc = "Search current word / selection",
      },
    },

    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "descending",
        layout_config = {
          prompt_position = "bottom",
        },
      },
      extensions = {
        frecency = {
          show_scores = false,
          show_unindexed = false,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
          default_workspace = "CWD",
          auto_validate = true,
        },
      },
    },

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("frecency")
    end,
  },
}
