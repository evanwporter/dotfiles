local M = {}

M.config = {
  keyword_highlight = {
    fg = "Black", -- contrasting text
    bg = "#7dcfff", -- bright blue from todo-comments info color
    bold = true,
  },
  pattern = "^TODO:",
}

local ns_id = vim.api.nvim_create_namespace("markdown_todo_highlight")

local function highlight_buffer(bufnr)
  -- Clear existing highlights
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  -- Get all lines in buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for line_num, line in ipairs(lines) do
    -- Match TODO: at the start of the line
    local todo_start, todo_end = line:find(M.config.pattern)

    if todo_start then
      -- Highlight only the "TODO:" part
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, "MarkdownTodoKeyword", line_num - 1, todo_start - 1, todo_end)
    end
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Define highlight group for TODO: keyword only
  vim.api.nvim_set_hl(0, "MarkdownTodoKeyword", vim.tbl_extend("force", M.config.keyword_highlight, { default = true }))

  -- Create autocommand group
  local group = vim.api.nvim_create_augroup("MarkdownTodoHighlight", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    group = group,
    pattern = "*.md",
    callback = function(ev)
      highlight_buffer(ev.buf)
    end,
  })

  -- Highlight current buffer if it's markdown
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  if current_file:match("%.md$") then
    highlight_buffer(current_buf)
  end
end

return M
