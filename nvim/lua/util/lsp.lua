local M = {
    servers = {},
}

function M.add_servers(servers)
    M.servers = vim.tbl_deep_extend("force", M.servers, servers)
end

return M
