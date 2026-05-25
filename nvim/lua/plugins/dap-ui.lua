return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      -- Keep auto-open when debugging starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end

      -- Disable LazyVim's auto-close behavior
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil
    end,
  },
}