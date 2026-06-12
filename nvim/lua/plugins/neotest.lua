return {
  {
    dir = vim.fn.expand("~/neotest-ctest"),
    name = "neotest-ctest",
    dev = true,
  },

  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-ctest"] = {
          build_dir = "build/clang-debug",

          is_test_file = function(file)
            local name = vim.fs.basename(file)

            return name:match("_test%.cpp$")
              or name:match("_tests%.cpp$")
              or name:match("^test_.*%.cpp$")
              or name:match("tests%.cpp$")
              or name:match("Tests%.cpp$")
          end,
        },
      },
    },
  },
}
