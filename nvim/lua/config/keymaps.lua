vim.keymap.set("n", "<localleader>a", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select All" })

vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>", {
  desc = "Quit All",
})

vim.keymap.set("n", "<leader>bd", function()
  vim.cmd("bdelete")
end, {
  desc = "Delete Buffer",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
    end

    map("gd", vim.lsp.buf.definition, "Go to Definition")
    map("gD", vim.lsp.buf.declaration, "Go to Declaration")
    map("gr", vim.lsp.buf.references, "Go to References")
    map("gi", vim.lsp.buf.implementation, "Go to Implementation")
    map("K", vim.lsp.buf.hover, "Hover Documentation")

    map("<leader>cn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

    map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
    map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
  end,
})
