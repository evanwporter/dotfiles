local dashboard_ns = vim.api.nvim_create_namespace("dashboard")

local dashboard_art = vim.split(
    [[
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
]],
    "\n",
    { trimempty = true }
)

local function get_dashboard_lines()
    local lazy_stats = package.loaded.lazy and package.loaded.lazy.stats
    local stats = lazy_stats and lazy_stats() or { loaded = 0, startuptime = 0 }

    local lines = vim.deepcopy(dashboard_art)

    table.insert(lines, "")
    table.insert(lines, string.format("Loaded %d plugins in %.2f ms", stats.loaded, stats.startuptime))

    return lines
end

local function center_lines_in_window(lines, win)
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)

    local centered = {}
    local vertical_padding = math.max(math.floor((height - #lines) / 2), 0)

    for _ = 1, vertical_padding do
        table.insert(centered, "")
    end

    for _, line in ipairs(lines) do
        local horizontal_padding = math.max(math.floor((width - vim.fn.strdisplaywidth(line)) / 2), 0)
        table.insert(centered, string.rep(" ", horizontal_padding) .. line)
    end

    return centered
end

local function render_dashboard(buf, win)
    if not vim.api.nvim_buf_is_valid(buf) then
        return
    end

    if not win or not vim.api.nvim_win_is_valid(win) then
        win = vim.fn.bufwinid(buf)
    end

    if win == -1 or not vim.api.nvim_win_is_valid(win) then
        return
    end

    local lines = get_dashboard_lines()
    local centered = center_lines_in_window(lines, win)

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_clear_namespace(buf, dashboard_ns, 0, -1)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered)
    vim.bo[buf].modifiable = false

    vim.api.nvim_set_hl(0, "DashboardHeader", { link = "Title" })
    vim.api.nvim_set_hl(0, "DashboardFooter", { link = "Comment" })

    local vertical_padding = math.max(math.floor((vim.api.nvim_win_get_height(win) - #lines) / 2), 0)

    for i = 1, #dashboard_art do
        vim.api.nvim_buf_add_highlight(buf, dashboard_ns, "DashboardHeader", vertical_padding + i - 1, 0, -1)
    end

    vim.api.nvim_buf_add_highlight(buf, dashboard_ns, "DashboardFooter", vertical_padding + #lines - 1, 0, -1)
end

local function setup_dashboard_buffer(buf)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buflisted = false
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = true
    vim.bo[buf].filetype = "dashboard"
end

local function open_dashboard()
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    -- Don't replace a real file
    if vim.api.nvim_buf_get_name(buf) ~= "" then
        return
    end

    setup_dashboard_buffer(buf)
    render_dashboard(buf, win)
end

local function is_real_text_buffer(buf)
    return vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buflisted
        and vim.bo[buf].buftype == ""
        and vim.bo[buf].filetype ~= "dashboard"
        and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function has_real_text_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if is_real_text_buffer(buf) then
            return true
        end
    end

    return false
end

local function open_dashboard_if_no_text_buffers()
    if has_real_text_buffers() then
        return
    end

    open_dashboard()
end

local function refresh_dashboards()
    vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)

                if vim.bo[buf].filetype == "dashboard" then
                    render_dashboard(buf, win)
                end
            end
        end
    end)
end

local dashboard_opened = false

local function maybe_open_dashboard()
    if dashboard_opened then
        return
    end

    -- A session is restored on VimEnter. Avoid rendering a dashboard during
    -- UIEnter only to immediately replace it with the restored layout.
    if vim.g.session_restore_pending then
        return
    end

    if vim.fn.argc() > 0 then
        return
    end

    dashboard_opened = true
    open_dashboard()
end

vim.api.nvim_create_autocmd("UIEnter", {
    callback = maybe_open_dashboard,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = maybe_open_dashboard,
})

vim.api.nvim_create_autocmd("BufDelete", {
    callback = function()
        vim.schedule(open_dashboard_if_no_text_buffers)
    end,
})

vim.api.nvim_create_autocmd({
    "VimResized",
    "WinResized",
    "WinEnter",
    "BufWinEnter",
    "WinNew",
}, {
    callback = refresh_dashboards,
})
