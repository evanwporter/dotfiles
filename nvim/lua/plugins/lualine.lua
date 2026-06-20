return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      vim.o.showtabline = 0
      opts.tabline = {}

      local function is_normal_file_buffer()
        local ft = vim.bo.filetype
        local bt = vim.bo.buftype

        if bt ~= "" then
          return false
        end

        if ft:match("^snacks") then
          return false
        end

        return not vim.tbl_contains({
          "neo-tree",
          "NvimTree",
          "oil",
          "Trouble",
          "lazy",
        }, ft)
      end

      local buffer_winbar = {
        lualine_a = {
          {
            "buffers",
            mode = 0,
            show_filename_only = true,
            show_modified_status = true,
            cond = is_normal_file_buffer,
          },
        },
      }

      opts.winbar = buffer_winbar
      opts.inactive_winbar = buffer_winbar

      opts.options.disabled_filetypes = vim.tbl_deep_extend("force", opts.options.disabled_filetypes or {}, {
        winbar = {
          "neo-tree",
          "NvimTree",
          "oil",
          "Trouble",
          "lazy",
          "snacks_picker",
          "snacks_picker_input",
          "snacks_picker_list",
          "snacks_picker_preview",
          "snacks_dashboard",
          "snacks_terminal",
        },
      })
    end,
  },
}
