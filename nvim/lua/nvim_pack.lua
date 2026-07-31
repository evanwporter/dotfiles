-- Plugin orchestration.
-- vim.pack handles installation unless NVIM_PLUGIN_MANAGER=nix is set.
-- lz.n handles lazy-loading configuration in both modes.

local plugin_manager = vim.env.NVIM_PLUGIN_MANAGER or "vim.pack"
local use_nix_plugins = plugin_manager == "nix"

if not use_nix_plugins then
	-- Bootstrap lz.n via vim.pack
	vim.pack.add({ "https://github.com/lumen-oss/lz.n" })
end

-- Verify lz.n can be loaded
local ok, lzn = pcall(require, "lz.n")
if not ok then
	vim.notify("Failed to load lz.n for plugin manager: " .. plugin_manager, vim.log.levels.ERROR)
	return
end

if not use_nix_plugins then
	-- Install all plugins from sources.lua.
	-- Don't load them yet (lz.n will handle loading).
	local sources = require("sources")
	for _, spec in ipairs(sources) do
		if type(spec) == "string" then
			vim.pack.add({ spec }, { load = function() end })
		else
			-- Table spec with version or other options
			vim.pack.add({ spec }, { load = function() end })
		end
	end
end

lzn.load("plugins.lib")
lzn.load("plugins")
lzn.load("plugins.ui")
lzn.load("plugins.lsp")
lzn.load("plugins.coding")
lzn.load("plugins.editor")
lzn.load("plugins.treesitter")
lzn.load("plugins.dap")
lzn.load("plugins.test")

-- Setup autocmds for vim.pack
-- Note: PackChanged handler for build steps is in core/autocmd.lua
local augroup = function(name, fnc)
	fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

local aucmd = vim.api.nvim_create_autocmd

augroup("nvim-pack", function(g)
	-- Convenience keymap for nvim-pack buffer
	aucmd("FileType", {
		group = g,
		pattern = "nvim-pack",
		callback = function()
			vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = true })
		end,
	})
end)

-- vim.pack management user command
vim.api.nvim_create_user_command("Pack", function(e)
	local cmd = #e.fargs > 0 and table.remove(e.fargs, 1) or "status"
	local plugins = #e.fargs > 0 and e.fargs or nil

	if cmd == "status" or cmd == "st" then
		vim.pack.update(plugins, { offline = true })
	elseif cmd == "update" or cmd == "up" then
		vim.pack.update(plugins, {})
	elseif cmd == "restore" or cmd == "rs" then
		vim.pack.update(plugins, { target = "lockfile" })
	elseif cmd == "remove" or cmd == "rm" or cmd == "delete" or cmd == "del" then
		if plugins and #plugins > 0 then
			vim.pack.del(plugins)
		else
			vim.notify("Pack remove: must specify plugin(s)", vim.log.levels.WARN)
		end
	else
		vim.notify("Pack: unknown command '" .. cmd .. "'", vim.log.levels.WARN)
	end
end, {
	desc = "Manage vim.pack plugins",
	nargs = "*",
})

-- Command to view loaded/pending plugins
vim.api.nvim_create_user_command("Lazy", function()
	local loaded = {}
	local pending = {}

	-- Get all installed plugins from vim.pack
	local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
	for _, pack_type in ipairs({ "start", "opt" }) do
		for _, pack_name in ipairs({ "core", "dev" }) do
			local dir = pack_dir .. "/" .. pack_name .. "/" .. pack_type
			if vim.fn.isdirectory(dir) == 1 then
				for _, plugin in ipairs(vim.fn.readdir(dir)) do
					if plugin ~= "lz.n" then -- Skip lz.n itself
						local is_loaded = package.loaded[plugin] ~= nil
						if is_loaded then
							table.insert(loaded, plugin)
						else
							table.insert(pending, plugin)
						end
					end
				end
			end
		end
	end

	table.sort(loaded)
	table.sort(pending)

	local lines = { "# Plugin Status", "" }
	table.insert(lines, "## Loaded (" .. #loaded .. ")")
	for _, name in ipairs(loaded) do
		table.insert(lines, "  ✓ " .. name)
	end

	table.insert(lines, "")
	table.insert(lines, "## Pending (lazy-loaded) (" .. #pending .. ")")
	for _, name in ipairs(pending) do
		table.insert(lines, "  ○ " .. name)
	end

	-- Create scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "markdown"

	-- Open in split
	vim.cmd("split")
	vim.api.nvim_win_set_buf(0, buf)
end, { desc = "Show loaded/pending plugins" })
