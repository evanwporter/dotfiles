local function is_nixpkgs(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(filename, {
        "pkgs/top-level/all-packages.nix",
        "maintainers/maintainer-list.nix",
    })

    return root ~= nil
        and vim.uv.fs_stat(root .. "/pkgs/top-level/all-packages.nix") ~= nil
        and vim.uv.fs_stat(root .. "/maintainers/maintainer-list.nix") ~= nil
end

return {
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = {
            formatters_by_ft = {
                verilog = { "verible" },
                systemverilog = { "verible" },

                python = {
                    "ruff_fix",
                    "ruff_format",
                    "ruff_organize_imports",
                },

                lua = { "stylua" },

                json = { "prettier" },
                jsonc = { "prettier" },
                json5 = { "prettier" },
                yaml = { "prettier" },

                nix = function(bufnr)
                    return { is_nixpkgs(bufnr) and "nixfmt" or "alejandra" }
                end,

                -- cmake = { "cmake_format" },

                xml = { "xmlstarlet" },

                jinja = { "djlint" },

                sh = { "shfmt" },
                bash = { "shfmt" },
            },

            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4" },
                },
                alejandra = {
                    command = "alejandra",
                    args = {
                        "--experimental-config",
                        vim.fn.expand("~/.config/alejandra/alejandra.toml"),
                    },
                    xmlstarlet = {
                        args = { "fo", "--indent-tab" },
                    },
                },
            },

            format_on_save = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
        },
    },
}
