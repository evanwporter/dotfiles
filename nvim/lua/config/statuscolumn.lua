local M = {}

local defaults = {
  enabled = true,

  left = { "mark", "sign" },
  number = true,
  right = { "fold", "git" },

  folds = {
    open = false,
    git_hl = false,
  },

  git = {
    patterns = { "GitSign", "MiniDiffSign" },
  },

  refresh = 50,
}

local config = vim.deepcopy(defaults)

local C

local sign_cache = {}
local cache = {}
local icon_cache = {}

local did_setup = false

local function _ffi()
  if not C then
    local ffi = require("ffi")

    ffi.cdef([[
      typedef struct {} Error;
      typedef struct {} win_T;
      typedef struct {
        int start;
        int level;
        int llevel;
        int lines;
      } foldinfo_T;
      foldinfo_T fold_info(win_T* wp, int lnum);
      win_T *find_window_by_handle(int Window, Error *err);
    ]])

    C = ffi.C
  end

  return C
end

local function fold_info(win, lnum)
  pcall(_ffi)

  if not C then
    return nil
  end

  local ffi = require("ffi")
  local err = ffi.new("Error")
  local wp = C.find_window_by_handle(win, err)

  if wp == nil then
    return nil
  end

  return C.fold_info(wp, lnum)
end

function M.is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns or {}) do
    if name:find(pattern) then
      return true
    end
  end

  return false
end

function M.buf_signs(buf, wanted)
  local signs = {}

  if wanted.git or wanted.sign then
    if vim.fn.has("nvim-0.10") == 0 then
      local placed = vim.fn.sign_getplaced(buf, { group = "*" })

      for _, sign in ipairs(placed[1].signs or {}) do
        local defined = vim.fn.sign_getdefined(sign.name)[1]

        if defined then
          defined.priority = sign.priority
          defined.type = M.is_git_sign(sign.name) and "git" or "sign"

          signs[sign.lnum] = signs[sign.lnum] or {}

          if wanted[defined.type] then
            table.insert(signs[sign.lnum], defined)
          end
        end
      end
    end

    local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })

    for _, extmark in pairs(extmarks) do
      local lnum = extmark[2] + 1
      local details = extmark[4] or {}

      local name = details.sign_hl_group or details.sign_name or ""

      local ret = {
        name = name,
        type = M.is_git_sign(name) and "git" or "sign",
        text = details.sign_text,
        texthl = details.sign_hl_group,
        priority = details.priority,
      }

      signs[lnum] = signs[lnum] or {}

      if wanted[ret.type] then
        table.insert(signs[lnum], ret)
      end
    end
  end

  if wanted.mark then
    local marks = vim.fn.getmarklist(buf)
    vim.list_extend(marks, vim.fn.getmarklist())

    for _, mark in ipairs(marks) do
      if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
        local lnum = mark.pos[2]

        signs[lnum] = signs[lnum] or {}

        table.insert(signs[lnum], {
          text = mark.mark:sub(2),
          texthl = "StatusColumnMark",
          priority = 0,
          type = "mark",
        })
      end
    end
  end

  return signs
end

function M.line_signs(win, buf, lnum, wanted)
  local buf_signs = sign_cache[buf]

  if not buf_signs then
    buf_signs = M.buf_signs(buf, wanted)
    sign_cache[buf] = buf_signs
  end

  local signs = vim.deepcopy(buf_signs[lnum] or {})

  if wanted.fold then
    local info = fold_info(win, lnum)

    if info and info.level > 0 then
      if info.lines > 0 then
        signs[#signs + 1] = {
          text = vim.opt.fillchars:get().foldclose or "",
          texthl = "Folded",
          priority = 0,
          type = "fold",
        }
      elseif config.folds.open and info.start == lnum then
        signs[#signs + 1] = {
          text = vim.opt.fillchars:get().foldopen or "",
          texthl = "Folded",
          priority = 0,
          type = "fold",
        }
      end
    end
  end

  table.sort(signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)

  return signs
end

function M.icon(sign)
  if not sign then
    return "  "
  end

  local key = (sign.text or "") .. (sign.texthl or "")

  if icon_cache[key] then
    return icon_cache[key]
  end

  local text = vim.fn.strcharpart(sign.text or "", 0, 2)
  text = text .. string.rep(" ", 2 - vim.fn.strchars(text))

  local icon = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text

  icon_cache[key] = icon

  return icon
end

function M._get()
  local win = vim.g.statusline_winid

  if not win or win == 0 then
    return ""
  end

  local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)

  if not ok_buf then
    return ""
  end

  local nu = config.number and vim.wo[win].number
  local rnu = config.number and vim.wo[win].relativenumber

  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
  local show_folds = vim.v.virtnum == 0 and vim.wo[win].foldcolumn ~= "0"

  local left_c = type(config.left) == "function" and config.left(win, buf, vim.v.lnum) or config.left

  local right_c = type(config.right) == "function" and config.right(win, buf, vim.v.lnum) or config.right

  local wanted = {
    sign = show_signs,
  }

  for _, c in ipairs(left_c or {}) do
    wanted[c] = wanted[c] ~= false
  end

  for _, c in ipairs(right_c or {}) do
    wanted[c] = wanted[c] ~= false
  end

  local components = { "", "", "" }

  if not show_signs and not show_folds and not nu and not rnu then
    return ""
  end

  if (nu or rnu) and vim.v.virtnum == 0 then
    local num

    if rnu and nu and vim.v.relnum == 0 then
      num = vim.v.lnum
    elseif rnu then
      num = vim.v.relnum
    else
      num = vim.v.lnum
    end

    components[2] = "%=" .. num .. " "
  end

  if show_signs or show_folds then
    local signs = M.line_signs(win, buf, vim.v.lnum, wanted)

    if #signs > 0 then
      local signs_by_type = {}

      for _, s in ipairs(signs) do
        signs_by_type[s.type] = signs_by_type[s.type] or s
      end

      local function find(types)
        for _, t in ipairs(types or {}) do
          if signs_by_type[t] then
            return signs_by_type[t]
          end
        end
      end

      local left = find(left_c)
      local right = find(right_c)

      if config.folds.git_hl then
        local git = signs_by_type.git

        if git and left and left.type == "fold" then
          left.texthl = git.texthl
        end

        if git and right and right.type == "fold" then
          right.texthl = git.texthl
        end
      end

      components[1] = left and M.icon(left) or "  "
      components[3] = right and M.icon(right) or "  "
    else
      components[1] = "  "
      components[3] = "  "
    end
  end

  components[1] = vim.b[buf].statuscolumn_left ~= false and components[1] or ""
  components[3] = vim.b[buf].statuscolumn_right ~= false and components[3] or ""

  local ret = table.concat(components, "")

  return "%@v:lua.require'config.statuscolumn'.click_fold@" .. ret .. "%T"
end

function M.get()
  local win = vim.g.statusline_winid

  if not win or win == 0 then
    return ""
  end

  local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)

  if not ok_buf then
    return ""
  end

  local key = ("%d:%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)

  if cache[key] then
    return cache[key]
  end

  local ok, ret = pcall(M._get)

  if ok then
    cache[key] = ret
    return ret
  end

  return ""
end

function M.click_fold()
  local pos = vim.fn.getmousepos()

  if not pos or pos.winid == 0 then
    return
  end

  pcall(vim.api.nvim_win_set_cursor, pos.winid, { pos.line, 1 })

  vim.api.nvim_win_call(pos.winid, function()
    if vim.fn.foldlevel(pos.line) > 0 then
      vim.cmd("normal! za")
    end
  end)
end

function M.setup(opts)
  if did_setup then
    return
  end

  did_setup = true

  config = vim.tbl_deep_extend("force", defaults, opts or {})

  if not config.enabled then
    return
  end

  vim.api.nvim_set_hl(0, "StatusColumnMark", {
    link = "DiagnosticHint",
    default = true,
  })

  vim.o.statuscolumn = "%!v:lua.require'config.statuscolumn'.get()"

  local timer = assert((vim.uv or vim.loop).new_timer())

  timer:start(
    config.refresh,
    config.refresh,
    vim.schedule_wrap(function()
      sign_cache = {}
      cache = {}
    end)
  )
end

M.setup({
  enabled = true,

  left = { "mark", "sign" },
  number = true,
  right = { "fold", "git" },

  folds = {
    open = false,
    git_hl = false,
  },

  git = {
    patterns = { "GitSign", "MiniDiffSign" },
  },

  refresh = 50,
})

return M
