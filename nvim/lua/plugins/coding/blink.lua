-- blink.cmp - Modern completion plugin
-- Installation handled by lua/sources.lua

return {
	"blink.cmp",
	-- Load on InsertEnter or CmdlineEnter for completion
	lazy = true,
	event = { "InsertEnter", "CmdlineEnter" },
	beforeAll = function()
		-- Ensure blink.lib is loaded first (dependency)
		-- require("lz.n").trigger_load("blink.lib")
		-- require("lz.n").trigger_load("blink.lib")
		require("lz.n").trigger_load("friendly-snippets")
	end,
	after = function()
		require("blink.cmp").setup({
			snippets = {
				preset = "default",
			},

			signature = { enabled = true },

			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
			},

			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				documentation = {
					auto_show = true,
				},
			},

			keymap = {
				preset = "super-tab",
			},

			cmdline = {
				enabled = true,

				keymap = {
					preset = "inherit",

					-- Keep normal command-line cursor movement
					["<Right>"] = false,
					["<Left>"] = false,

					-- Cycle through candidates and update the inline preview
					["<Tab>"] = {
						"insert_next",
						"fallback",
					},

					["<S-Tab>"] = {
						"insert_prev",
						"fallback",
					},

					-- Accept the selected completion and execute the command
					["<CR>"] = {
						"accept_and_enter",
						"fallback",
					},

					-- Accept without executing
					["<C-y>"] = {
						"accept",
						"fallback",
					},

					-- Cancel the current completion
					["<C-e>"] = {
						"cancel",
						"fallback",
					},

					-- Manually show completion when needed
					["<C-Space>"] = {
						"show",
						"fallback",
					},
				},

				completion = {
					list = {
						selection = {
							preselect = false,
							auto_insert = true,
						},
					},

					menu = {
						auto_show = true,
					},

					ghost_text = {
						enabled = true,
					},
				},
			},
		})
	end,
}
