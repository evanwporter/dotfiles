return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        "<leader>bb",
        function()
          require("fzf-lua").buffers({
            -- winopts = {
            --   preview = {
            --     layout = "vertical", -- or "horizontal"
            --   },
            -- },
          })
        end,
        desc = "Find buffers",
      },
      -- {
      --   "grr",
      --   function()
      --     require("fzf-lua").lsp_references()
      --   end,
      --   desc = "LSP references",
      -- },
      {
        "<leader>sg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Search Grep",
      },
      {
        "<leader>sw",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Search Word Under Cursor",
      },
      { "gr", desc = "Go to References" },
      { "<leader>ss", desc = "Search Document Symbols" },
      { "<leader>sS", desc = "Search Workspace Symbols" },
    },
    opts = {
      fzf_opts = {
        ["--layout"] = "reverse-list",
      },
    },
  },
}
