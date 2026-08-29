return {
    {
        "hudson-trading/slang-server.nvim",
        cond = not vim.g.vscode,
        -- ft = { "verilog", "systemverilog" },
        cmd = { "SlangServer" },
        -- dependencies = { "MunifTanjim/nui.nvim" },
    },
}
