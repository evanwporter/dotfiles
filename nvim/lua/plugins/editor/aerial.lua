return {
  {
    "stevearc/aerial.nvim",
    opts = {
      guides = {
        mid_item = "├╴",
        last_item = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
  },
}
