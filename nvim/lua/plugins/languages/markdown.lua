return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    opts = {},
    ft = { "markdown" },
  },
  {
    name = "markdown-todo-highlight",
    dir = vim.fn.stdpath("config") .. "/lua/config/plugins/markdown-todo-highlight.nvim",
    opts = {},
    ft = { "markdown" },
  },
}
