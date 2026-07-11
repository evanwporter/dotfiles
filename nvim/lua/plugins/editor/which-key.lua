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
          { "<leader>q", group = "Quit", icon = "󰗼" },
          { "<leader>b", group = "Buffer", icon = "󰈔" },
          { "<leader>c", group = "Code", icon = "󰅩" },
          { "<leader>d", group = "Debug", icon = "󰃤" },
          { "<leader>e", group = "Explorer", icon = "󰙅" },
          { "<leader>s", group = "Find", icon = "󰈞" },
          { "<leader>t", group = "Test", icon = "󰙨" },
          { "<leader>y", group = "Yazi", icon = "󰇥" },
          { "<leader>x", group = "Trouble", icon = "" },
          { "<leader>g", group = "LazyGit", icon = "" },
          { "<C-w>h", hidden = true },
          { "<C-w>j", hidden = true },
          { "<C-w>k", hidden = true },
          { "<C-w>l", hidden = true },
        },
      },
    },
    keys = {},
  },
}
