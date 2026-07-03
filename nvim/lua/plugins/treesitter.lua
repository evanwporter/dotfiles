return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    -- enabled = false,

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
  {
    "romus204/tree-sitter-manager.nvim",
    enabled = false,
    lazy = false,
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require("tree-sitter-manager").setup()
    end,
  },
}
