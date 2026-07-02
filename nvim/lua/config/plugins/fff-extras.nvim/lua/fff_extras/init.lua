local M = {}

local buffers = require("fff_extras.buffers")

M.opts = {}

function M.setup(opts)
  M.opts = opts or {}

  if buffers.setup then
    buffers.setup(M.opts.buffers or M.opts)
  end
end

function M.buffers(opts)
  opts = vim.tbl_deep_extend("force", M.opts or {}, opts or {})
  return buffers.buffers(opts)
end

function M.open_buffers(opts)
  return M.buffers(opts)
end

return M
