return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    opts = {
      -- ensure_installed = {
      --   "c",
      --   "cpp",
      --   "cmake",
      --   "json",
      --   "lua",
      --   "markdown",
      --   "python",
      --   "rust",
      --   "toml",
      --   "typescript",
      -- },
    },
  },
}
