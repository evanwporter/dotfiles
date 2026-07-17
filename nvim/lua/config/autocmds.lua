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

local function source_file(event, command)
    vim.keymap.set("n", "<localleader>s", function()
        vim.cmd.write()

        local file = vim.api.nvim_buf_get_name(event.buf)
        local result = vim.system(vim.list_extend(vim.deepcopy(command), { file }), {
            text = true,
        }):wait()

        if result.code == 0 then
            vim.notify("Sourced " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO)
        else
            vim.notify(result.stderr ~= "" and result.stderr or "Failed to source " .. file, vim.log.levels.ERROR)
        end
    end, {
        buffer = event.buf,
        silent = true,
        desc = "Source file",
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("source_shell_files"),
    pattern = { "bash", "sh", "tmux", "fish", "dotenv" },
    callback = function(event)
        local commands = {
            bash = { "bash", "-c", 'source "$1"', "bash" },
            sh = { "bash", "-c", 'source "$1"', "bash" },
            tmux = { "tmux", "source-file" },
            fish = { "fish", "-c", 'source "$argv[1]"' },
            dotenv = { "bash", "-c", 'set -a; source "$1"; set +a', "bash" },
        }

        local command = commands[vim.bo[event.buf].filetype]
        if command then
            source_file(event, command)
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("source_fish_files"),
    pattern = "*.fish",
    callback = function(event)
        source_file(event, { "fish", "-c", 'source "$argv[1]"' })
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("source_tmux_files"),
    pattern = { ".tmux.conf", "tmux.conf" },
    callback = function(event)
        source_file(event, { "tmux", "source-file" })
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("source_env_files"),
    pattern = ".env*",
    callback = function(event)
        source_file(event, { "bash", "-c", 'set -a; source "$1"; set +a', "bash" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
