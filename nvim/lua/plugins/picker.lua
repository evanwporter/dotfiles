return {
  {
    dir = vim.fn.expand("~/dotfiles/nvim/lua/config/plugins/fff-extras.nvim/"),
    dependencies = {
      "dmtrKovalenko/fff",
    },
    keys = {
      -- Buffers picker
      {
        "<leader>fb",
        function()
          require("fff_extras").buffers()
        end,
        desc = "Find Buffers",
      },

      -- Git picker (files in git repo)
      {
        "<leader>fi",
        function()
          require("fff_extras").git_files()
        end,
        desc = "Find Git files",
      },
    },
  },

  {
    "dmtrKovalenko/fff",

    build = function(plugin)
      local plugin_dir = plugin and plugin.dir or vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
      local binary_dir = plugin_dir .. "/target/release"
      local final_path = binary_dir .. "/libfff_nvim.so"
      local tmp_path = final_path .. ".tmp"

      vim.fn.mkdir(binary_dir, "p")

      -- Get latest release JSON
      local api_url = "https://api.github.com/repos/dmtrKovalenko/fff/releases/latest"
      local json = vim.fn.system({
        "curl",
        "--fail",
        "--location",
        "--silent",
        "--show-error",
        api_url,
      })
      if vim.v.shell_error ~= 0 or not json or json == "" then
        error("fff.nvim: failed to fetch latest release metadata")
      end

      local ok, release = pcall(vim.json.decode, json)
      if not ok or type(release) ~= "table" then
        error("fff.nvim: could not parse GitHub releases response")
      end

      -- Find the x86_64-unknown-linux-gnu.so asset
      local asset_url = nil
      for _, asset in ipairs(release.assets or {}) do
        if asset.name == "x86_64-unknown-linux-gnu.so" then
          asset_url = asset.browser_download_url
          break
        end
      end

      if not asset_url then
        error("fff.nvim: no x86_64-unknown-linux-gnu.so asset found in latest release")
      end

      -- Download to tmp file
      local out = vim.fn.system({
        "curl",
        "--fail",
        "--location",
        "--silent",
        "--show-error",
        "--output",
        tmp_path,
        asset_url,
      })
      if vim.v.shell_error ~= 0 then
        error("fff.nvim: binary download failed:\n" .. (out or "unknown error"))
      end

      -- Move tmp to final name
      if vim.loop.fs_stat(final_path) then
        vim.loop.fs_unlink(final_path)
      end
      local ok_rename, rename_err = vim.loop.fs_rename(tmp_path, final_path)
      if not ok_rename then
        if vim.loop.fs_stat(tmp_path) then
          vim.loop.fs_unlink(tmp_path)
        end
        error("fff.nvim: failed to install downloaded binary: " .. (rename_err or "unknown error"))
      end
    end,

    keys = {
      {
        "<leader><leader>",
        function()
          require("fff").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fb",
        function()
          require("fff").buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fw",
        function()
          require("fff").live_grep_under_cursor()
        end,
        mode = { "n", "x" },
        desc = "Find word under cursor",
      },
    },

    init = function()
      local function set_fff_highlights()
        vim.api.nvim_set_hl(0, "FFFCursorLine", {
          bg = "#504945",
        })
      end

      set_fff_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_fff_highlights,
      })
    end,

    opts = {
      prompt = " ",

      hl = {
        cursor = "FFFCursorLine",
      },

      debug = {
        enabled = false,
        show_scores = false,
      },

      preview = {
        enabled = true,
        cursorlineopt = "both",
      },
    },

    config = function(_, opts)
      require("fff").setup(opts)
    end,
  },

  -- {
  --   dir = vim.fn.expand("~/dotfiles/nvim/plugins/fff-buffers.nvim"),
  --   name = "fff-buffers.nvim",
  --   dependencies = {
  --     "dmtrKovalenko/fff.nvim",
  --   },
  --   opts = {},
  --   keys = {
  --     {
  --       "<leader>fb",
  --       function()
  --         require("fff_buffers").buffers()
  --       end,
  --       desc = "Find buffers",
  --     },
  --   },
  -- },
  --
  {
    "nvim-telescope/telescope-frecency.nvim",
    version = "^1.0.0",
    enabled = false,
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    keys = {
      -- Files by frecency
      {
        "<leader><leader>",
        function()
          require("telescope").extensions.frecency.frecency()
        end,
        desc = "Find files",
      },

      -- Buffers (MRU)
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true,
            ignore_current_buffer = true,
          })
        end,
        desc = "Buffers",
      },

      -- Live grep
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live grep",
      },

      -- Grep word / selection under cursor
      {
        "<leader>fw",
        function()
          local builtin = require("telescope.builtin")
          local mode = vim.api.nvim_get_mode().mode
          if mode == "v" or mode == "V" or mode == "\22" then
            -- visual selection
            local _, ls, cs = unpack(vim.fn.getpos("'<"))
            local _, le, ce = unpack(vim.fn.getpos("'>"))
            local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
            if #lines == 0 then
              builtin.live_grep()
              return
            end
            lines[#lines] = string.sub(lines[#lines], 1, ce)
            lines[1] = string.sub(lines[1], cs)
            local text = table.concat(lines, "\n")
            builtin.live_grep({ default_text = text })
          else
            -- normal mode: use <cword>
            builtin.live_grep({ default_text = vim.fn.expand("<cword>") })
          end
        end,
        mode = { "n", "x" },
        desc = "Search current word / selection",
      },
    },

    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "descending",
        layout_config = {
          prompt_position = "bottom",
        },
      },
      extensions = {
        frecency = {
          show_scores = false,
          show_unindexed = false,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
          default_workspace = "CWD",
          auto_validate = true,
        },
      },
    },

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("frecency")
    end,
  },
}
