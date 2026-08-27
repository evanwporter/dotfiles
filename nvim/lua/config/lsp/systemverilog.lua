local inactive_regions_ns = vim.api.nvim_create_namespace("SlangServerInactiveRegions")
local inactive_region_hl = "SlangServerInactiveRegion"

vim.api.nvim_set_hl(0, inactive_region_hl, {
    link = "Comment",
    default = true,
})

---@param uri string
---@param ranges lsp.Range[]
local function apply_inactive_region_highlights(uri, ranges)
    local bufnr = vim.fn.bufnr(vim.uri_to_fname(uri), false)
    if bufnr == -1 then
        return
    end

    vim.api.nvim_buf_clear_namespace(bufnr, inactive_regions_ns, 0, -1)

    for _, range in ipairs(ranges) do
        vim.api.nvim_buf_set_extmark(bufnr, inactive_regions_ns, range.start.line, range.start.character, {
            end_row = range["end"].line,
            end_col = range["end"].character,
            hl_group = inactive_region_hl,
            hl_eol = true,
        })
    end
end

---@class slang-server.InactiveRegionsParams
---@field uri string
---@field regions lsp.Range[]

---@param err lsp.ResponseError?
---@param params slang-server.InactiveRegionsParams?
local function inactive_regions_handler(err, params, _, _)
    if err or not params or not params.uri or not params.regions then
        return
    end

    apply_inactive_region_highlights(params.uri, params.regions)
end

vim.lsp.config("slang_server", {
    -- cmd = { vim.fn.expand("~/slang-server/build/debug/bin/slang-server") },
    filetypes = { "systemverilog", "verilog" },
    root_markers = { ".git", ".slang" },
    capabilities = {
        experimental = {
            inactiveRegions = {
                inactiveRegions = true,
            },
        },
    },
    handlers = {
        ["textDocument/inactiveRegions"] = inactive_regions_handler,
    },
})

vim.lsp.enable("slang_server")
