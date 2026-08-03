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
    group = augroup("source_shell_file"),
    pattern = { "fish", "sh" },
    callback = function(event)
        vim.keymap.set("n", "<localleader>s", function()
            local path = vim.api.nvim_buf_get_name(event.buf)

            if path == "" then
                vim.notify("Cannot source an unnamed buffer", vim.log.levels.WARN)
                return
            end

            local ok, err = pcall(vim.cmd.write)

            if not ok then
                vim.notify("Could not save before sourcing: " .. err, vim.log.levels.ERROR)
                return
            end

            local shell = vim.bo[event.buf].filetype == "fish" and "fish" or "bash"
            local cmd = shell == "fish" and { "fish", "-c", "source $argv[1]", path }
                or { "bash", "-c", 'source "$1"', "bash", path }

            vim.system(cmd, { text = true }, function(result)
                vim.schedule(function()
                    if result.code == 0 then
                        vim.notify("Sourced " .. vim.fn.fnamemodify(path, ":~:."))
                        return
                    end

                    local output = vim.trim((result.stderr or "") .. "\n" .. (result.stdout or ""))

                    if output == "" then
                        output = shell .. " exited with code " .. result.code
                    end

                    vim.notify(output, vim.log.levels.ERROR)
                end)
            end)
        end, {
            buffer = event.buf,
            desc = "Source Shell File",
            silent = true,
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("user_inlay_hints"),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf

        -- Define excluded filetypes here if needed (e.g., { "markdown", "help" })
        local exclude_filetypes = {}

        if
            client
            and client:supports_method("textDocument/inlayHint", { bufnr = buf })
            and vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buftype == ""
            and not vim.tbl_contains(exclude_filetypes, vim.bo[buf].filetype)
        then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        end
    end,
})
