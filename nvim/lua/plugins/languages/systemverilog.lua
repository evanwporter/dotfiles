return {
    {
        "hudson-trading/slang-server.nvim",
        enabled = false,
        cond = not vim.g.vscode,
        ft = { "verilog", "systemverilog" },
        -- cmd = { "SlangServer" },
        dependencies = { "MunifTanjim/nui.nvim" },
    },
}
