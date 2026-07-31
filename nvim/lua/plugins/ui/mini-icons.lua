-- mini.icons - Icon provider
-- Installation handled by lua/sources.lua

return {
    "mini.icons",
    -- Load immediately so it's available for other plugins
    priority = 100,
    after = function()
        require("mini.icons").setup({})
    end,
}
