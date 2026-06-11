return {
  {
    "r4ppz/lspeek.nvim",
    event = "LspAttach",

    config = function()
      require("lspeek").setup({
        window = {
          width = 70,
          height = 15,
          border = "single",
        },

        stack_limit = 5,
        select_first = false,

        keymaps = {
          close = "q",
          split = "s",
          vsplit = "v",
          enter = "<CR>",
        },
      })
    end,

    keys = {
      {
        "gz",
        function()
          require("lspeek").peek_definition()
        end,
        desc = "Peek Definition",
      },
      {
        "gZ",
        function()
          require("lspeek").peek_type_definition()
        end,
        desc = "Peek Type Definition",
      },
    },
  },
}
