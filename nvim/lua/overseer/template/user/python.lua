return {
  name = "Run current Python file",
  builder = function()
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "python" },
      args = { file },
      components = {
        "default",
        "on_output_quickfix",
        "on_result_diagnostics",
      },
    }
  end,
  condition = {
    filetype = { "python" },
  },
}
