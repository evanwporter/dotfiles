return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    -- lazy = false,

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

    keys = {
      {
        "<leader><leader>",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>fz",
        function()
          require("fff").live_grep({
            grep = {
              modes = { "fuzzy", "plain" },
            },
          })
        end,
        desc = "Live Fuzzy Grep",
      },
      {
        "<leader>fw",
        function()
          require("fff").live_grep_under_cursor()
        end,
        mode = { "n", "x" },
        desc = "Search Word / Selection",
      },
    },
  },
}
