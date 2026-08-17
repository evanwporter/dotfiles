vim.lsp.config("neocmake", {
    cmd = {
        "neocmakelsp",
        "stdio",
    },
    filetypes = {
        "cmake",
    },
    root_markers = {
        "CMakePresets.json",
        "CTestConfig.cmake",
        ".git",
    },
    init_options = {
        buildDirectory = "build",
    },
})
vim.lsp.enable("neocmake")

-- neocmakelsp `signature_help` hack
-- check is there an ) after this character in the current line and there are only spaces between them
local function check_condition()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local i = col + 1
    while i <= #line do
        local c = line:sub(i, i)
        if c == ")" then
            return true
        elseif c:match("%s") then
            i = i + 1
        else
            return false
        end
    end
    return false
end
-- check whether send signature_help request when inserting new text
vim.api.nvim_create_autocmd("InsertCharPre", {
    pattern = { "CMakeLists.txt", "*.cmake" },
    callback = function()
        local char = vim.v.char
        if (char == " " or char == "\n") and check_condition() then
            vim.defer_fn(vim.lsp.buf.signature_help, 20)
        end
    end,
})
-- check whether send signature_help request when enter insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = { "CMakeLists.txt", "*.cmake" },
    callback = function()
        if check_condition() then
            vim.defer_fn(vim.lsp.buf.signature_help, 30)
        end
    end,
})
