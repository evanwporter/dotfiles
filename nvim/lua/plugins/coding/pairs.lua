-- blink.pairs - Auto pairs
-- Installation handled by lua/sources.lua

return {
    "blink.pairs",
    event = "DeferredUIEnter",
    beforeAll = function()
        -- Ensure blink.lib is loaded first (dependency)
        require("lz.n").trigger_load("blink.lib")
    end,
    after = function()
        local pairs = require("blink.pairs")

        -- Download binary before setup (for vim.pack)
        local ok = pcall(function()
            pairs.download():pwait(60000)
        end)
        if not ok then
            vim.notify("blink.pairs: failed to download binary", vim.log.levels.ERROR)
            return
        end

        pairs.setup({
            mappings = {
                pairs = {
                    ['"'] = {
                        {
                            '"',
                            enter = false,
                            space = false,
                            when = function(ctx)
                                local next_char = ctx:text_after_cursor(1)
                                return not next_char:match("%w")
                            end,
                        },
                    },
                    ["'"] = {
                        {
                            "'",
                            enter = false,
                            space = false,
                            when = function(ctx)
                                local next_char = ctx:text_after_cursor(1)
                                return not next_char:match("%w")
                            end,
                        },
                    },
                    ["`"] = {
                        {
                            "`",
                            enter = false,
                            space = false,
                            when = function(ctx)
                                local next_char = ctx:text_after_cursor(1)
                                return not next_char:match("%w")
                            end,
                        },
                    },
                    ["("] = {
                        {
                            ")",
                            when = function(ctx)
                                local next_char = ctx:text_after_cursor(1)
                                return not next_char:match("%w")
                            end,
                        },
                    },
                    ["["] = {
                        {
                            "]",
                            when = function(ctx)
                                local next_char = ctx:text_after_cursor(1)
                                return not next_char:match("%w")
                            end,
                        },
                    },
                    ["{"] = {
                        {
                            "}",
                            when = function(ctx)
                                local next_char = ctx:text_after_cursor(1)
                                return not next_char:match("%w")
                            end,
                        },
                    },
                    ["<"] = {
                        {
                            ">",
                            when = function(ctx)
                                local next_char = ctx:text_after_cursor(1)
                                return not next_char:match("%w")
                            end,
                        },
                    },
                },
            },
        })
    end,
}
