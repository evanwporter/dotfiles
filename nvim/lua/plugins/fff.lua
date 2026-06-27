return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false, -- fff lazy-initialises itself
    opts = {
      prompt = " ",
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
