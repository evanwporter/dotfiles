return {
  { "ellisonleao/gruvbox.nvim" },

  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "light"

      require("solarized").setup(opts)

      -- Black cursor in insert mode
      vim.opt.guicursor = {
        "n-v-c:block-Cursor",
        "i-ci-ve:ver25-CursorInsert",
        "r-cr:hor20-Cursor",
        "o:hor50-Cursor",
      }

      vim.api.nvim_set_hl(0, "CursorInsert", {
        fg = "#fdf6e3",
        bg = "#000000",
      })
    end,
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
