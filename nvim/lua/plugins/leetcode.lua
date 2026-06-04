return {
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    -- build = ":TSUpdate html",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "cpp",
      injector = {
        ["cpp"] = {
          imports = function()
            -- return a different list to omit default imports
            return { "#include <bits/stdc++.h>", "using namespace std;" }
          end,
          after = "int main() {}",
        },
      },
    },
  },
}
