-- close some filetypes with <q>
local augroup = require("util.autocmd").augroup

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "checkhealth",
        "dap-float",
        "dbout",
        "gitsigns-blame",
        "grug-far",
        "help",
        "lspinfo",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "notify",
        "qf",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "q", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        if vim.fn.has("nvim-0.13") == 1 then
            vim.hl.hl_op()
        else
            (vim.hl or vim.highlight).on_yank()
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("yaml_indent"),
    pattern = "yaml",
    callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.tabstop = 4
    end,
})
