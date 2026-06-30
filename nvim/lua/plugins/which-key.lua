return {
  {
    "folke/which-key.nvim",
    dependencies = {
      "nvim-mini/mini.icons",
    },
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>q", group = "Quit All", icon = "󰗼" },
          { "<leader>b", group = "Buffer", icon = "󰈔" },
          { "<leader>c", group = "Code", icon = "󰅩" },
          { "<leader>d", group = "Debug", icon = "󰃤" },
          { "<leader>e", group = "Explorer", icon = "󰙅" },
          { "<leader>f", group = "Find", icon = "󰈞" },
          { "<leader>t", group = "Test", icon = "󰙨" },
          { "<leader>y", group = "Yazi", icon = "󰇥" },
        },
      },
    },
    keys = {},
  },
}
