-- FFF Extras - Clean API for fff.nvim extensions
local M = {}

--- Open buffer picker
--- @param opts? table Optional configuration
function M.buffers(opts)
  return require("fff_extras.buffers").buffers(opts)
end

--- Open git files picker
--- @param opts? table Optional configuration
function M.git_files(opts)
  return require("fff_extras.git_files").git_files(opts)
end

--- Open old files picker
--- @param opts? table Optional configuration
function M.oldfiles(opts)
  return require("fff_extras.oldfiles").oldfiles(opts)
end

return M
