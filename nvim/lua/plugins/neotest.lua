return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"evanwporter/neotest-ctest",
		},
		config = function()
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
				},
			})

			vim.keymap.set("n", "<leader>tn", function()
				neotest.run.run()
			end, { desc = "Run nearest test" })

			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Run test file" })

			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, { desc = "Debug nearest test" })

			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { desc = "Toggle test summary" })

			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true })
			end, { desc = "Open test output" })

			vim.keymap.set("n", "<leader>tO", function()
				neotest.output_panel.toggle()
			end, { desc = "Toggle test output panel" })

			vim.keymap.set("n", "<leader>tS", function()
				neotest.run.stop()
			end, { desc = "Stop test" })
		end,
	},
}
