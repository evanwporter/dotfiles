return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup()
    end,
  },
}
