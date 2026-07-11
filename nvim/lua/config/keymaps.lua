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
    map("gr", function()
      require("fzf-lua").lsp_references()
    end, "Go to References")
    map("gi", vim.lsp.buf.implementation, "Go to Implementation")

    map("K", vim.lsp.buf.hover, "Hover Documentation")

    map("<leader>cr", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")

    map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next Diagnostic")

    map("<leader>ss", function()
      require("fzf-lua").lsp_document_symbols()
    end, "Search Document Symbols")

    map("<leader>sS", function()
      require("fzf-lua").lsp_live_workspace_symbols()
    end, "Search Workspace Symbols")

    map("<leader>cx", function()
      vim.cmd("Trouble diagnostics toggle")
    end, "Diagnostics")

    map("<leader>cX", function()
      vim.cmd("Trouble diagnostics toggle filter.buf=0")
    end, "Buffer Diagnostics")
  end,
})

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("harpoon"):list():select(i)
  end, { desc = "which_key_ignore" })
end
