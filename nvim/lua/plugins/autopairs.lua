return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      disable_filetype = {
        "TelescopePrompt",
        "vim",
        "systemverilog",
        "verilog",
        "spectre_panel",
        "snacks_picker_input",
      },
    })
  end,
}
