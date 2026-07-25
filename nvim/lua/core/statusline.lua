local M = {}

-- Don't show the command that produced the quickfix list.
vim.g.qf_disable_statusline = 1

local api = vim.api
local fn = vim.fn

local mode_backgrounds = {
    normal = "#a89984",
    insert = "#a9b665",
    visual = "#ea6962",
    replace = "#d8a657",
    command = "#7daea3",
    terminal = "#d3869b",
    other = "#504945",
}

local mode_foreground = "#282828"
local section_foreground = "#ddc7a1"
local git_background = "#504945"
local filetype_background = "#32302f"
local path_min_width = 24
local path_max_width = 80

local function set_highlights()
    api.nvim_set_hl(0, "StatusLineModeNormal", {
        fg = mode_foreground,
        bg = mode_backgrounds.normal,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineModeInsert", {
        fg = mode_foreground,
        bg = mode_backgrounds.insert,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineModeVisual", {
        fg = mode_foreground,
        bg = mode_backgrounds.visual,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineModeReplace", {
        fg = mode_foreground,
        bg = mode_backgrounds.replace,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineModeCommand", {
        fg = mode_foreground,
        bg = mode_backgrounds.command,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineModeTerminal", {
        fg = mode_foreground,
        bg = mode_backgrounds.terminal,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineModeOther", {
        fg = mode_foreground,
        bg = mode_backgrounds.other,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineGitBranch", {
        fg = section_foreground,
        bg = git_background,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLineFiletype", {
        fg = section_foreground,
        bg = filetype_background,
        bold = true,
    })

    api.nvim_set_hl(0, "StatusLinePathFile", { link = "StatusLine" })
    api.nvim_set_hl(0, "StatusLineModified", { link = "DiagnosticWarn" })
end

set_highlights()

---@return string, string
local function get_mode()
    local mode = api.nvim_get_mode().mode

    if vim.startswith(mode, "i") then
        return "INSERT", "StatusLineModeInsert"
    elseif vim.startswith(mode, "n") then
        return "NORMAL", "StatusLineModeNormal"
    elseif vim.startswith(mode, "R") then
        return "REPLACE", "StatusLineModeReplace"
    elseif mode == "v" then
        return "VISUAL", "StatusLineModeVisual"
    elseif mode == "V" then
        return "V-LINE", "StatusLineModeVisual"
    elseif mode == "\22" then
        return "V-BLOCK", "StatusLineModeVisual"
    elseif mode == "c" then
        return "COMMAND", "StatusLineModeCommand"
    elseif mode == "t" then
        return "TERMINAL", "StatusLineModeTerminal"
    elseif mode == "s" then
        return "SELECT", "StatusLineModeVisual"
    elseif mode == "S" then
        return "S-LINE", "StatusLineModeVisual"
    elseif mode == "\19" then
        return "S-BLOCK", "StatusLineModeVisual"
    else
        return mode:upper(), "StatusLineModeOther"
    end
end

---@return integer
local function statusline_bufnr()
    local winid = vim.g.statusline_winid

    if type(winid) == "number" and api.nvim_win_is_valid(winid) then
        return api.nvim_win_get_buf(winid)
    end

    return api.nvim_get_current_buf()
end

---@return integer
local function statusline_width()
    local winid = vim.g.statusline_winid

    if type(winid) == "number" and api.nvim_win_is_valid(winid) then
        return api.nvim_win_get_width(winid)
    end

    return vim.o.columns
end

---@param path string
---@return integer
local function path_display_width(path)
    return fn.strdisplaywidth(path)
end

---@param path string
---@param max_width integer
---@return string
local function truncate_path(path, max_width)
    if path_display_width(path) <= max_width then
        return path
    end

    local shortened = fn.pathshorten(path)

    if path_display_width(shortened) <= max_width then
        return shortened
    end

    local prefix = "..."
    local tail_width = math.max(1, max_width - #prefix)
    local tail = fn.strcharpart(shortened, math.max(0, fn.strchars(shortened) - tail_width))

    return prefix .. tail
end

---@return integer
local function max_path_width()
    return math.max(path_min_width, math.min(path_max_width, math.floor(statusline_width() * 0.45)))
end

---@return string
M.mode = function()
    local name, hl = get_mode()

    return string.format("%%#%s# %s %%*", hl, name)
end

---@return string
M.git_branch = function()
    local bufnr = statusline_bufnr()
    local branch = vim.b[bufnr].gitsigns_head or vim.g.gitsigns_head

    if not branch or branch == "" then
        return ""
    end

    return string.format("%%#StatusLineGitBranch#  %s %%*", branch)
end

---@return string
M.path_file = function()
    local bufnr = statusline_bufnr()
    local bufname = api.nvim_buf_get_name(bufnr)

    if bufname == "" then
        return "%#StatusLinePathFile# [No Name] %*"
    end

    local cwd = fn.getcwd()
    local filename = fn.fnamemodify(bufname, ":.")

    -- If the file is outside the current working directory,
    -- display a shortened absolute path.
    if filename == bufname then
        filename = fn.fnamemodify(bufname, ":~")
    elseif vim.startswith(filename, cwd) then
        filename = fn.fnamemodify(bufname, ":.")
    end

    filename = truncate_path(filename, max_path_width())

    return string.format("%%#StatusLinePathFile# %s %%*", filename)
end

---@return string
M.modified = function()
    local bufnr = statusline_bufnr()

    if not vim.bo[bufnr].modified then
        return ""
    end

    return "%#StatusLineModified# ● %*"
end

---@return string
M.readonly = function()
    local bufnr = statusline_bufnr()

    if not vim.bo[bufnr].readonly then
        return ""
    end

    return "%#DiagnosticWarn#  %*"
end

---@return string
M.position = function()
    local _, hl = get_mode()
    local winid = vim.g.statusline_winid

    if type(winid) ~= "number" or not api.nvim_win_is_valid(winid) then
        winid = api.nvim_get_current_win()
    end

    local cursor = api.nvim_win_get_cursor(winid)

    return string.format("%%#%s# %d:%d %%*", hl, cursor[1], cursor[2] + 1)
end

---@return string
M.filetype = function()
    local bufnr = statusline_bufnr()
    local filetype = vim.bo[bufnr].filetype

    if filetype == "" then
        filetype = "text"
    end

    local icon = ""
    local ok, mini_icons = pcall(require, "mini.icons")

    if ok then
        icon = mini_icons.get("filetype", filetype) or icon
    end

    return string.format("%%#StatusLineFiletype# %s %s %%*", icon, filetype)
end

---@return string
M.render = function()
    return table.concat({
        M.mode(),
        M.git_branch(),
        M.path_file(),
        M.modified(),
        M.readonly(),

        -- Fill the unused remainder with StatusLine.
        "%#StatusLine#%=",

        M.filetype(),
        M.position(),
    })
end

vim.opt.laststatus = 3
vim.opt.statusline = "%!v:lua.require'core.statusline'.render()"

api.nvim_create_autocmd("ColorScheme", {
    group = api.nvim_create_augroup("CustomStatusLine", { clear = true }),
    callback = set_highlights,
})

return M
