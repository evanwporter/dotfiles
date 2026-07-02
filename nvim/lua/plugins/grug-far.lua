return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require("grug-far").setup({
        window = {
          position = "right", -- "right", "left", "top", "bottom", or "center"
          width = 0.4, -- fraction of total width (if side window)
        },
      })
    end,

    keys = {
      {
        "<leader>fr",
        function()
          require("grug-far").open()
        end,
        desc = "Find and Replace",
      },
      -- {
      --   "<leader>sw",
      --   function()
      --     require("grug-far").open({
      --       prefills = {
      --         search = vim.fn.expand("<cword>"),
      --       },
      --     })
      --   end,
      --   desc = "Search current word",
      -- },
      {
        "<leader>fR",
        function()
          require("grug-far").open({
            prefills = {
              paths = vim.fn.expand("%"),
            },
          })
        end,
        desc = "Find and Replace in File",
      },
    },
  },
}
