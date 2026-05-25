return {
  {
    "folke/persistence.nvim",
    init = function()
      vim.opt.sessionoptions = {
        "blank",
        "buffers",
        "curdir",
        "folds",
        "globals",
        "help",
        "localoptions",
        "resize",
        "tabpages",
        "terminal",
        "winpos",
        "winsize",
      }
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
        callback = function()
          if vim.fn.getcwd() ~= vim.env.HOME then
            require("persistence").load()
          end
        end,
        nested = true,
      })
    end,
  },
}
