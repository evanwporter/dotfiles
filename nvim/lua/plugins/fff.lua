return {
  {
    "evanwporter/fff.nvim",

    build = function(plugin)
      local url = "https://github.com/evanwporter/fff.nvim/releases/latest/download/nvim-x86_64-unknown-linux-gnu.zip"

      local script = string.format(
        [[
        set -e

        URL=%q
        TMP_DIR="$(mktemp -d)"
        OUT_DIR=%q
        OUT_LIB="$OUT_DIR/libfff_nvim.so"

        mkdir -p "$OUT_DIR"

        echo "Downloading latest fff.nvim binary..."
        curl -fL "$URL" -o "$TMP_DIR/fff.zip"

        echo "Extracting fff.nvim binary..."
        unzip -o "$TMP_DIR/fff.zip" -d "$TMP_DIR/unpacked"

        LIB="$(find "$TMP_DIR/unpacked" -type f \( -name 'libfff_nvim.so' -o -name '*.so' \) | head -n 1)"

        if [ -z "$LIB" ]; then
          echo "Could not find .so file in downloaded archive"
          find "$TMP_DIR/unpacked" -type f
          exit 1
        fi

        cp "$LIB" "$OUT_LIB"
        chmod +x "$OUT_LIB"

        rm -rf "$TMP_DIR"

        echo "Installed fff.nvim binary to $OUT_LIB"
      ]],
        url,
        plugin.dir .. "/target/release"
      )

      local result = vim.system({ "sh", "-c", script }, { text = true }):wait()

      if result.code ~= 0 then
        error("Failed to install fff.nvim binary:\n" .. (result.stdout or "") .. "\n" .. (result.stderr or ""))
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
        "fw",
        function()
          require("fff").live_grep_under_cursor()
        end,
        mode = { "n", "x" },
        desc = "Search current word / selection",
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
}
