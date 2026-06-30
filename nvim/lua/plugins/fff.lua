return {
  {
    "vinitkumar/fff.nvim",
    build = "cargo build --release",

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
}
