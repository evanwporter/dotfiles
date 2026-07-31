-- nvim-rip-substitute - Fast search and replace
-- Installation handled by lua/sources.lua

return {
    "nvim-rip-substitute",
    lazy = true,
    keys = {
        {
            "g/",
            function()
                require("rip-substitute").sub()
            end,
            mode = { "n", "x" },
            desc = "Quick Find/Replace",
        },
    },
    after = function()
        require("rip-substitute").setup({
            prefill = {
                visual = false,
            },
            keymaps = {
                insertModeConfirmAndSubstituteInBuffer = "<CR>",
            },
        })

        -- Tab navigation in rip-substitute buffer
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "rip-substitute",
            callback = function(event)
                vim.keymap.set("i", "<Tab>", function()
                    local win = vim.fn.bufwinid(event.buf)
                    if win == -1 then return end

                    local cursor = vim.api.nvim_win_get_cursor(win)
                    local next_line = math.min(cursor[1] + 1, vim.api.nvim_buf_line_count(event.buf))
                    local line = vim.api.nvim_buf_get_lines(event.buf, next_line - 1, next_line, false)[1] or ""
                    local next_col = math.min(cursor[2], #line)

                    vim.api.nvim_win_set_cursor(win, { next_line, next_col })
                end, {
                    buffer = event.buf,
                    silent = true,
                    desc = "Rip Substitute: Next line",
                })
            end,
        })
    end,
}
