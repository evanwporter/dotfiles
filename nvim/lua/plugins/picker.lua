return {
  {
    "vinitkumar/fff.nvim",
    build = function(plugin)
      local upstream_repo = "dmtrKovalenko/fff.nvim"

      local function run(cmd, opts)
        opts = opts or {}
        local result = vim.system(cmd, opts):wait()

        if result.code ~= 0 then
          return nil, table.concat(cmd, " ") .. " failed:\n" .. (result.stderr or result.stdout or "")
        end

        return result.stdout or "", nil
      end

      local function mkdir_p(dir)
        vim.fn.mkdir(dir, "p")
      end

      local function file_exists(path)
        local stat = vim.uv.fs_stat(path)
        return stat and stat.type == "file"
      end

      local function download(url, output)
        local out, err = run({
          "curl",
          "--fail",
          "--location",
          "--silent",
          "--show-error",
          "--output",
          output,
          url,
        })

        return out ~= nil, err
      end

      local function get_latest_asset_url(asset_name)
        -- GitHub's /latest endpoint may skip prereleases, so use /releases.
        -- fff.nvim publishes nightlies/prereleases, so this is more reliable.
        local api_url = "https://api.github.com/repos/" .. upstream_repo .. "/releases?per_page=30"

        local json, err = run({
          "curl",
          "--fail",
          "--location",
          "--silent",
          "--show-error",
          api_url,
        })

        if not json then
          local binary_dir = plugin_dir .. "/../target/release"
          return nil, err
        end

        local ok, releases = pcall(vim.json.decode, json)
        if not ok or type(releases) ~= "table" then
          return nil, "Could not parse GitHub releases response"
        end

        for _, release in ipairs(releases) do
          for _, asset in ipairs(release.assets or {}) do
            if asset.name == asset_name then
              return asset.browser_download_url, release.tag_name
            end
          end
        end

        return nil, "No upstream release asset found for " .. asset_name
      end

      local function build_from_source()
        local fff_download = require("fff.download")

        local done = false
        local fatal_error = nil

        fff_download.build_binary(function(success, err)
          if not success then
            fatal_error = err or "unknown error"
          end
          done = true
        end)

        local ok, wait_err = vim.wait(1000 * 60 * 2, function()
          return done
        end, 100)

        if not ok and wait_err == -2 then
          error("fff.nvim: cargo build timed out")
        end

        if fatal_error then
          error("fff.nvim: cargo build failed: " .. fatal_error)
        end
      end

      local system = require("fff.utils.system")

      local plugin_dir = plugin and plugin.dir or vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")

      local extension = system.get_lib_extension()
      local triple = system.get_triple()

      local asset_name = triple .. "." .. extension

      local binary_dir = plugin_dir .. "/target/release"
      local binary_path = binary_dir .. "/libfff_nvim." .. extension
      local tmp_path = binary_path .. ".tmp"

      mkdir_p(binary_dir)

      local asset_url, tag_or_err = get_latest_asset_url(asset_name)

      if not asset_url then
        vim.notify(
          "fff.nvim: could not find latest upstream binary: "
            .. (tag_or_err or "unknown error")
            .. "\nFalling back to cargo build --release",
          vim.log.levels.WARN
        )
        build_from_source()
        return
      end

      vim.notify("fff.nvim: downloading upstream binary " .. asset_name .. " from " .. tag_or_err, vim.log.levels.INFO)

      if file_exists(tmp_path) then
        vim.uv.fs_unlink(tmp_path)
      end

      local ok, err = download(asset_url, tmp_path)

      if not ok then
        vim.notify(
          "fff.nvim: binary download failed: " .. (err or "unknown error") .. "\nFalling back to cargo build --release",
          vim.log.levels.WARN
        )
        build_from_source()
        return
      end

      local loader, load_err = package.loadlib(tmp_path, "luaopen_fff_nvim")

      if not loader then
        vim.uv.fs_unlink(tmp_path)
        vim.notify(
          "fff.nvim: downloaded binary is invalid: "
            .. (load_err or "unknown error")
            .. "\nFalling back to cargo build --release",
          vim.log.levels.WARN
        )
        build_from_source()
        return
      end

      if file_exists(binary_path) then
        vim.uv.fs_unlink(binary_path)
      end

      local rename_ok, rename_err = vim.uv.fs_rename(tmp_path, binary_path)

      if not rename_ok then
        vim.uv.fs_unlink(tmp_path)
        error("fff.nvim: failed to install downloaded binary: " .. (rename_err or "unknown error"))
      end

      vim.notify("fff.nvim: upstream binary installed successfully", vim.log.levels.INFO)
    end,
    -- enabled = false,

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
