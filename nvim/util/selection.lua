local M = {}

---Return the current visual selection as text.
---@param opts? { multiline?: boolean }
---@return string|nil
function M.get_visual_selection(opts)
  opts = opts or {}

  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end

  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })

  if not lines or vim.tbl_isempty(lines) then
    return nil
  end

  local separator = opts.multiline and "\n" or " "
  local selection = table.concat(lines, separator)

  if not opts.multiline then
    selection = selection:gsub("%s+", " ")
  end

  selection = vim.trim(selection)

  if selection == "" then
    return nil
  end

  return selection
end

return M
