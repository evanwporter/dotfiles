return {
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      local npairs = require("nvim-autopairs")

      npairs.setup(opts)

      -- Disable backtick autopairing in Verilog/SystemVerilog files
      local backtick_rules = npairs.get_rules("`")
      if backtick_rules and backtick_rules[1] then
        backtick_rules[1].not_filetypes = {
          "systemverilog",
          "verilog",
        }
      end
    end,
  },
}
