-------------------------------------------------------------------------------
-- LSP KEYMAPS
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if not client then
            return
        end

        -- Remove Neovim's default LSP mappings for this buffer
        local default_keys = { "grn", "gra", "grr", "gri" }
        for _, keys in ipairs(default_keys) do
            pcall(vim.keymap.del, "n", keys, { buffer = event.buf })
        end

        local function map(keys, func, desc, method)
            if method and not client:supports_method(method, event.buf) then
                return
            end

            vim.keymap.set("n", keys, func, {
                buffer = event.buf,
                desc = desc,
                silent = true,
            })
        end

        map("gd", function()
            require("fzf-lua").lsp_definitions()
        end, "Go to Definition", "textDocument/definition")

        map("gD", function()
            require("fzf-lua").lsp_declarations()
        end, "Go to Declaration", "textDocument/declaration")

        map("gr", function()
            require("fzf-lua").lsp_references()
        end, "Go to References", "textDocument/references")

        map("gi", function()
            require("fzf-lua").lsp_implementations()
        end, "Go to Implementation", "textDocument/implementation")

        map("gy", function()
            require("fzf-lua").lsp_typedefs()
        end, "Go to T[y]pe Definition", "textDocument/typeDefinition")
        -- map("gK", function()
        --     return vim.lsp.buf.signature_help()
        -- end, "Signature Help", "textDocument/signatureHelp")

        map("gai", function()
            require("fzf-lua").lsp_incoming_calls()
        end, "LSP Incoming Calls", "callHierarchy/incomingCalls")

        map("gao", function()
            require("fzf-lua").lsp_outgoing_calls()
        end, "LSP Outgoing Calls", "callHierarchy/outgoingCalls")

        map("K", vim.lsp.buf.hover, "Hover Documentation", "textDocument/hover")

        map("<leader>cr", vim.lsp.buf.rename, "Rename", "textDocument/rename")

        map("<leader>ca", function()
            require("fzf-lua").lsp_code_actions()
        end, "Code Action", "textDocument/codeAction")

        map("<leader>sd", function()
            require("fzf-lua").lsp_document_symbols()
        end, "Search Document Symbols", "textDocument/documentSymbol")

        map("<leader>sD", function()
            require("fzf-lua").lsp_live_workspace_symbols()
        end, "Search Workspace Symbols", "workspace/symbol")

        map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")

        -- Navigate to previous diagnostic
        map("[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous Diagnostic")

        -- Navigate to next diagnostic
        map("]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, "Next Diagnostic")

        map("<leader>cx", function()
            require("fzf-lua").diagnostics_document()
        end, "Diagnostics Document")

        map("<leader>cX", function()
            require("fzf-lua").diagnostics_workspace()
        end, "Diagnostics Workspace")
    end,
})

-------------------------------------------------------------------------------
-- WINDOW NAVIGATION
-------------------------------------------------------------------------------
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-------------------------------------------------------------------------------
-- SCROLLING
-------------------------------------------------------------------------------
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })

-------------------------------------------------------------------------------
-- MACROS
-------------------------------------------------------------------------------
vim.keymap.set("n", "Q", "q", { desc = "Start/stop macro recording" })
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable accidental macro recording" })

-------------------------------------------------------------------------------
-- INDENTATION
-------------------------------------------------------------------------------
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and reselect" })

-------------------------------------------------------------------------------
-- TEXT SELECTION
-------------------------------------------------------------------------------
vim.keymap.set("n", "<localleader>a", "ggVG", { desc = "Select All" })

-------------------------------------------------------------------------------
-- MOTION ENHANCEMENTS
-------------------------------------------------------------------------------
vim.keymap.set("n", "j", function()
    if vim.v.count == 0 and vim.fn.line(".") == vim.fn.line("$") then
        return "$"
    end

    return "j"
end, {
    expr = true,
    silent = true,
    desc = "Down",
})

vim.keymap.set({ "n", "x" }, "k", function()
    if vim.v.count == 0 and vim.fn.line(".") == 1 then
        return "0"
    end

    return "k"
end, {
    expr = true,
    silent = true,
    desc = "Up",
})

-------------------------------------------------------------------------------
-- QUICKFIX LIST NAVIGATION
-------------------------------------------------------------------------------
vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "Prev Quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix" })
vim.keymap.set("n", "[Q", "<cmd>cfirst<cr>", { desc = "First Quickfix" })
vim.keymap.set("n", "]Q", "<cmd>clast<cr>", { desc = "Last Quickfix" })
vim.keymap.set("n", "[<C-q>", "<cmd>cpfile<cr>", { desc = "Prev Quickfix File" })
vim.keymap.set("n", "]<C-q>", "<cmd>cnfile<cr>", { desc = "Next Quickfix File" })

-------------------------------------------------------------------------------
-- LOCATION LIST NAVIGATION
-------------------------------------------------------------------------------
vim.keymap.set("n", "[l", "<cmd>lprevious<cr>", { desc = "Prev Location Item" })
vim.keymap.set("n", "]l", "<cmd>lnext<cr>", { desc = "Next Location Item" })
vim.keymap.set("n", "[L", "<cmd>lfirst<cr>", { desc = "First Location Item" })
vim.keymap.set("n", "]L", "<cmd>llast<cr>", { desc = "Last Location Item" })
vim.keymap.set("n", "[<C-l>", "<cmd>lpfile<cr>", { desc = "Prev Location File" })
vim.keymap.set("n", "]<C-l>", "<cmd>lnfile<cr>", { desc = "Next Location File" })

-------------------------------------------------------------------------------
-- TAG NAVIGATION
-------------------------------------------------------------------------------
vim.keymap.set("n", "[t", "<cmd>tprevious<cr>", { desc = "Prev Tag" })
vim.keymap.set("n", "]t", "<cmd>tnext<cr>", { desc = "Next Tag" })
vim.keymap.set("n", "[T", "<cmd>tfirst<cr>", { desc = "First Tag" })
vim.keymap.set("n", "]T", "<cmd>tlast<cr>", { desc = "Last Tag" })
vim.keymap.set("n", "[<C-t>", "<cmd>ptprevious<cr>", { desc = "Prev Preview Tag" })
vim.keymap.set("n", "]<C-t>", "<cmd>ptnext<cr>", { desc = "Next Preview Tag" })

-------------------------------------------------------------------------------
-- COMMENTS
-------------------------------------------------------------------------------
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-------------------------------------------------------------------------------
-- COPY / PASTE / REGISTERS
-------------------------------------------------------------------------------
-- Use x and Del key for black hole register
vim.keymap.set("x", "<Del>", '"_x', { silent = true, desc = "Delete without yanking" })
vim.keymap.set("x", "x", '"_x', { silent = true, desc = "Delete without yanking" })

-------------------------------------------------------------------------------
-- QUIT
-------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
