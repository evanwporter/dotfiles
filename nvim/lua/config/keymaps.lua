vim.keymap.set("n", "<localleader>a", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select All" })

vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", {
  desc = "Quit",
})

vim.keymap.set("n", "<leader>bd", function()
  local bufnr = vim.api.nvim_get_current_buf()

  local listed = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf ~= bufnr
  end, vim.api.nvim_list_bufs())

  if #listed > 0 then
    vim.cmd("buffer " .. listed[#listed])
  else
    vim.cmd("enew")
  end

  vim.cmd("bdelete " .. bufnr)
end, {
  desc = "Delete Buffer",
})

vim.api.nvim_create_user_command("BdeleteAll", function()
  vim.cmd("%bd")
end, {
  desc = "Delete all buffers",
})

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", {
  desc = "Next Buffer",
})

vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", {
  desc = "Previous Buffer",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer = event.buf,
        desc = desc,
      })
    end

    map("gd", vim.lsp.buf.definition, "Go to Definition")
    map("gD", vim.lsp.buf.declaration, "Go to Declaration")
    map("gr", vim.lsp.buf.references, "Go to References")
    map("gi", vim.lsp.buf.implementation, "Go to Implementation")
    map("K", vim.lsp.buf.hover, "Hover Documentation")

    map("<leader>cr", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")

    map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
  end,
})

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("harpoon"):list():select(i)
  end, { desc = "which_key_ignore" })
end

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })
