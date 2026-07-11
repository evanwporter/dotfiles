return {
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({
        openTargetWindow = {
          preferredLocation = "right",
          exclude = {
            "dashboard",
          },
        },
      })

      -- Insert mode <Tab> goes to the next grug-far input
      local group = vim.api.nvim_create_augroup("grug-far-tab-navigation", {
        clear = true,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "grug-far",
        callback = function(event)
          vim.keymap.set("i", "<Tab>", function()
            local instance = require("grug-far").get_instance(event.buf)

            if instance then
              instance:goto_next_input()
            end
          end, {
            buffer = event.buf,
            silent = true,
            desc = "Grug Far: Next input",
          })

          vim.keymap.set("i", "<S-Tab>", function()
            local instance = require("grug-far").get_instance(event.buf)

            if instance then
              instance:goto_prev_input()
            end
          end, {
            buffer = event.buf,
            silent = true,
            desc = "Grug Far: Previous input",
          })
        end,
      })
    end,
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace",
      },
      {
        "<leader>sR",
        function()
          require("grug-far").open({
            transient = true,
            prefills = {
              paths = vim.fn.expand("%"),
            },
          })
        end,
        desc = "Find and Replace in File",
        mode = { "n", "x" },
      },
    },
  },
}
