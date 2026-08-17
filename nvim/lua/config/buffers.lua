vim.keymap.set("n", "<leader>bo", function()
    local current = vim.api.nvim_get_current_buf()

    local listed = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf)
            and vim.api.nvim_buf_is_loaded(buf)
            and vim.bo[buf].buflisted
            and buf ~= current
    end, vim.api.nvim_list_bufs())

    if #listed == 0 then
        vim.notify("No other buffers to delete", vim.log.levels.INFO)
        return
    end

    for _, buf in ipairs(listed) do
        vim.api.nvim_buf_delete(buf, { force = false })
    end
end, {
    desc = "Delete Other Buffers",
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

vim.keymap.set("n", "<leader>ba", function()
    local listed = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
    end, vim.api.nvim_list_bufs())

    if #listed == 0 then
        vim.notify("No buffers to delete", vim.log.levels.INFO)
        return
    end

    -- Create a temporary buffer so the current buffer can also be deleted.
    vim.cmd("enew")
    local empty_buf = vim.api.nvim_get_current_buf()
    vim.bo[empty_buf].buflisted = false

    for _, buf in ipairs(listed) do
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = false })
        end
    end
end, {
    desc = "Delete All Buffers",
})

-------------------------------------------------------------------------------
-- BUFFER NAVIGATION
-------------------------------------------------------------------------------
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
