-- https://lazyvim-ambitious-devs.phillips.codes/course/chapter-13/#_nvim_rip_substitute

return {
  "chrisgrieser/nvim-rip-substitute",
  keys = {
    {
      "g/",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = "Rip Substitute",
    },
  },
}
