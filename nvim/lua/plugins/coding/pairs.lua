return {
    {
        "saghen/blink.pairs",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            "saghen/blink.lib",
        },
        build = function()
            require("blink.pairs").download():pwait(60000)
        end,
        opts = {
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
        },
    },
}
