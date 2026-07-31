-- neotest - Test runner framework
-- Installation handled by lua/sources.lua

return {
    "neotest",
    lazy = true,
    keys = {
        {
            "<leader>tt",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle test summary",
        },
    },
    before = function()
        -- Load adapter plugins before neotest
        require("lz.n").trigger_load({ "neotest-ctest", "neotest-python", "nvim-nio", "plenary.nvim" })
    end,
    after = function()
        local neotest = require("neotest")

        neotest.setup({
            adapters = {
                require("neotest-ctest").setup({
                    build_dir = "build/debug",

                    dap_adapter = "codelldb",

                    is_test_file = function(file)
                        local name = vim.fs.basename(file)

                        return name:match("_test%.cpp$")
                            or name:match("_tests%.cpp$")
                            or name:match("^test_.*%.cpp$")
                            or name:match("tests%.cpp$")
                            or name:match("Tests%.cpp$")
                    end,
                }),
                require("neotest-python")({
                    dap = { justMyCode = false },
                    args = { "--log-level", "DEBUG" },
                    runner = "pytest",
                }),
            },
        })
    end,
}
