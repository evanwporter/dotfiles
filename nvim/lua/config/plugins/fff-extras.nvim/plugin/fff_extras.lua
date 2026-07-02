vim.api.nvim_create_user_command("FFFBuffers", function()
  require("fff_extras").buffers()
end, {})
