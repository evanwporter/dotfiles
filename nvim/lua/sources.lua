-- Plugin installation sources
-- This file only defines WHERE to download plugins from
-- Configuration lives in lua/plugins/*.lua

return {
    -- Icons
    "https://github.com/echasnovski/mini.icons",

    -- File explorer
    "https://github.com/stevearc/oil.nvim",

    -- Theme
    "https://github.com/sainnhe/gruvbox-material",

    -- Fuzzy finders
    "https://github.com/ibhagwan/fzf-lua",
    { src = "https://github.com/dmtrKovalenko/fff", version = "63fac0b45534be1645c9f23713963e45172dc89b" },

    -- Which-key
    "https://github.com/folke/which-key.nvim",

    -- Flash - jump/search motion
    "https://github.com/folke/flash.nvim",

    -- Git
    "https://github.com/lewis6991/gitsigns.nvim",

    -- Navigation
    { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

    -- Search and Replace
    "https://github.com/chrisgrieser/nvim-rip-substitute",
    "https://github.com/MagicDuck/grug-far.nvim",

    -- Training
    "https://github.com/m4xshen/hardtime.nvim",
    "https://github.com/MunifTanjim/nui.nvim",

    -- Completion
    { src = "https://github.com/saghen/blink.lib", version = "main" },
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },  -- Pin to last v1 tag before v2 migration
    "https://github.com/rafamadriz/friendly-snippets",

    -- Blink plugins
    { src = "https://github.com/saghen/blink.indent", version = vim.version.range("*") },
    { src = "https://github.com/saghen/blink.pairs", version = "v0.6.0" },  -- Pin to specific tag

    -- Formatting
    "https://github.com/stevearc/conform.nvim",

    -- Treesitter
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",

    -- DAP (Debug Adapter Protocol)
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/igorlfs/nvim-dap-view",
    "https://github.com/nvim-lua/plenary.nvim",

    -- Neotest
    "https://github.com/nvim-neotest/neotest",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/evanwporter/neotest-ctest",
    "https://github.com/nvim-neotest/neotest-python",

    -- LSP
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/b0o/schemastore.nvim",

    -- Mason
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/jay-babu/mason-nvim-dap.nvim",

    -- Language-specific plugins
    "https://github.com/dmmulroy/ts-error-translator.nvim",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/p00f/clangd_extensions.nvim",
    "https://github.com/Civitasv/cmake-tools.nvim",

}
