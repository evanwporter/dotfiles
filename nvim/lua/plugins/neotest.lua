return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "evanwporter/neotest-ctest",
            "nvim-neotest/neotest-python",
        },
        keys = {
            {
                "<leader>tn",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run nearest test",
            },
            -- {
            --     "<leader>tf",
            --     function()
            --         require("neotest").run.run(vim.fn.expand("%"))
            --     end,
            --     desc = "Run test file",
            -- },
            {
                "<leader>td",
                function()
                    require("neotest").run.run({ strategy = "dap" })
                end,
                desc = "Debug nearest test",
            },
            {
                "<leader>tt",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle test summary",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({ enter = true })
                end,
                desc = "Open test output",
            },
            {
                "<leader>tO",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Toggle test output panel",
            },
            -- {
            --     "<leader>tS",
            --     function()
            --         require("neotest").run.stop()
            --     end,
            --     desc = "Stop test",
            -- },
        },
        config = function()
            local neotest = require("neotest")
            local ctest = require("neotest-ctest").setup({
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
            })

            local ctest_results = ctest.results
            ctest.results = function(spec, result, tree)
                if type(spec.strategy) ~= "table" then
                    return ctest_results(spec, result, tree)
                end

                -- A DAP run launches the test executable directly, so CTest
                -- never creates the JUnit file expected by the adapter.
                local results = {}
                local status = result.code == 0 and "passed" or "failed"
                for _, node in tree:iter() do
                    results[node.id] = { status = status }
                end
                return results
            end

            neotest.setup({
                adapters = {
                    ctest,
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = "pytest",
                    }),
                },
            })
        end,
    },
}
