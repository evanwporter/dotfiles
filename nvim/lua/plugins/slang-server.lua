return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      slang_server = {
        -- Tell LazyVim that Mason isn't needed since this is a manual config
        mason = false,
        cmd = { "/home/evanw/slang-server/build/clang-debug/bin/slang-server" },
        filetypes = { "systemverilog", "verilog", "slang" },
        root_markers = { ".slang", ".git" },
        single_file_support = true,
      },
    },
  },
}
