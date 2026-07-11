vim.keymap.set("n", "<localleader>a", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select All" })

vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", {
  desc = "Quit",
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

    map("<leader>sd", function()
      require("fzf-lua").lsp_document_symbols()
    end, "Search Document Symbols")

    map("<leader>sD", function()
      require("fzf-lua").lsp_live_workspace_symbols()
    end, "Search Workspace Symbols")

    map("<leader>cx", function()
      require("fzf-lua").diagnostics_document()
    end, "Diagnostics Document")

    map("<leader>cX", function()
      require("fzf-lua").diagnostics_workspace()
    end, "Buffer Workspace")
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

vim.keymap.set("n", "Q", "q", { desc = "Start/stop macro recording" })
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable accidental macro recording" })
