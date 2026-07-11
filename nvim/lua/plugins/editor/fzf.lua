local selection = require("util.selection")

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
            --     layout = "vertical", - or "horizontal"
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
        "<leader>ss",
        "<cmd>FzfLua resume<cr>",
        desc = "Resume Fzf search",
      },
      {
        "<leader>sg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sg",
        function()
          require("fzf-lua").live_grep({ search = selection.get_visual_selection() })
        end,
        mode = "x",
        desc = "Grep Selection",
      },
      {
        "<leader>sw",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Search Word Under Cursor",
      },
      { "gr", desc = "Go to References" },
      { "<leader>sd", desc = "Search Document Symbols" },
      { "<leader>sD", desc = "Search Workspace Symbols" },
      { "<leader>cx", desc = "Diagnostics Document" },
      { "<leader>cX", desc = "Diagnostics Workspace" },
    },
    opts = {
      fzf_opts = {
        ["--layout"] = "reverse-list",
      },
    },
  },
}
