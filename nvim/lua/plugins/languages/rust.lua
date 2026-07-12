require("util.lsp").add_servers({
    rust_analyzer = {},
})

return {
    {
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup()
        end,
    },
}
