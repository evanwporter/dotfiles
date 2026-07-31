-- nvim-treesitter-textobjects - Syntax aware text-objects
-- Installation handled by lua/sources.lua
-- Configuration is in treesitter.lua (loaded via before hook)

return {
    "nvim-treesitter-textobjects",
    lazy = true,
    before = function()
        -- Disable entire built-in ftplugin mappings to avoid conflicts.
        vim.g.no_plugin_maps = true
    end,
}
