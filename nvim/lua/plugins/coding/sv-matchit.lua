return {
    {
        "evanwporter/sv-matchit.nvim",
        ft = { "verilog", "systemverilog" },
        build = "nix develop --command cargo build --release",
        opts = {},
    },
}
