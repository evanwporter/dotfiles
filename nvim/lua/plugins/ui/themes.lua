return {
  -- { "ellisonleao/gruvbox.nvim" },

  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
    end,
  },

  -- { "folke/tokyonight.nvim", enabled = false },
  --
  -- {
  --   "maxmx03/solarized.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function(_, opts)
  --     vim.o.background = "light"
  --
  --     require("solarized").setup(opts)
  --
  --     -- Black cursor in insert mode
  --     vim.opt.guicursor = {
  --       "n-v-c:block-Cursor",
  --       "i-ci-ve:ver25-CursorInsert",
  --       "r-cr:hor20-Cursor",
  --       "o:hor50-Cursor",
  --     }
  --
  --     vim.api.nvim_set_hl(0, "CursorInsert", {
  --       fg = "#fdf6e3",
  --       bg = "#000000",
  --     })
  --   end,
  --   enabled = false,
  -- },

  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   enabled = false,
  -- },
}
