local dashboard_art = [[
⠀⠀⠀⠀⠀⠀⠀⠀⣤⡀⠀⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣆⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠸⣷⣮⣿⣿⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⡠⠒⠉⠀⠀⠀⠀⠀⠀⠈⠁⠲⢖⠒⡀⠀⠀
⠀⠀⠀⡠⠴⣏⠀⢀⡀⠀⢀⡀⠀⠀⠀⡀⠀⠀⡀⠱⡈⢄⠀
⠀⠀⢠⠁⠀⢸⠐⠁⠀⠄⠀⢸⠀⠀⢎⠀⠂⠀⠈⡄⢡⠀⢣
⠀⢀⠂⠀⠀⢸⠈⠢⠤⠤⠐⢁⠄⠒⠢⢁⣂⡐⠊⠀⡄⠀⠸
⠀⡘⠀⠀⠀⢸⠀⢠⠐⠒⠈⠀⠀⠀⠀⠀⠀⠈⢆⠜⠀⠀⢸
⠀⡇⠀⠀⠀⠀⡗⢺⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⡄⢀⠎
⠀⢃⠀⠀⠀⢀⠃⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠷⡃⠀
⠀⠈⠢⣤⠀⠈⠀⠀⠑⠠⠤⣀⣀⣀⣀⣀⡀⠤⠒⠁⠀⢡⠀
⡀⣀⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⠀
⠑⢄⠉⢳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠀
⠀⠀⠑⠢⢱⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠁⠀
⠀⠀⠀⠀⢀⠠⠓⠢⠤⣀⣀⡀⠀⠀⣀⣀⡀⠤⠒⠑⢄⠀⠀
⠀⠀⠀⠰⠥⠤⢄⢀⡠⠄⡈⡀⠀⠀⣇⣀⠠⢄⠀⠒⠤⠣⠀
⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀
]]

local function show_dashboard(force)
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    if not force and vim.api.nvim_buf_get_name(buf) ~= "" then
        return
    end

    -- Create new buffer if current one has content
    if force and vim.api.nvim_buf_get_name(buf) ~= "" then
        vim.cmd("enew")
        buf = vim.api.nvim_get_current_buf()
    end

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buflisted = false
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "dashboard"

    local lines = vim.split(dashboard_art, "\n", { trimempty = true })
    local stats = package.loaded.lazy and package.loaded.lazy.stats()
    if stats then
        table.insert(lines, "")
        table.insert(lines, string.format("Loaded %d plugins in %.2f ms", stats.loaded, stats.startuptime))
    end

    -- Center lines
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)
    local vertical_padding = math.max(math.floor((height - #lines) / 2), 0)

    local centered = {}
    for _ = 1, vertical_padding do
        table.insert(centered, "")
    end
    for _, line in ipairs(lines) do
        local horizontal_padding = math.max(math.floor((width - vim.fn.strdisplaywidth(line)) / 2), 0)
        table.insert(centered, string.rep(" ", horizontal_padding) .. line)
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered)
    vim.bo[buf].modifiable = false

    -- Highlighting
    vim.api.nvim_set_hl(0, "DashboardHeader", { link = "Title" })
    vim.api.nvim_set_hl(0, "DashboardFooter", { link = "Comment" })

    local ns = vim.api.nvim_create_namespace("dashboard")
    for i = 1, #lines - 2 do -- Art lines
        vim.api.nvim_buf_set_extmark(buf, ns, vertical_padding + i - 1, 0, {
            end_col = 0,
            end_row = vertical_padding + i,
            hl_group = "DashboardHeader",
            hl_eol = true,
        })
    end
    vim.api.nvim_buf_set_extmark(buf, ns, vertical_padding + #lines - 1, 0, {
        end_col = 0,
        end_row = vertical_padding + #lines,
        hl_group = "DashboardFooter",
        hl_eol = true,
    })
end

local function has_real_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        if vim.fn.argc() == 0 and not vim.g.session_restore_pending then
            show_dashboard()
        end
    end,
})

vim.api.nvim_create_autocmd("BufDelete", {
    callback = function()
        vim.schedule(function()
            if not has_real_buffers() then
                show_dashboard()
            end
        end)
    end,
})

vim.api.nvim_create_user_command("Dashboard", function()
    show_dashboard(true)
end, {})
