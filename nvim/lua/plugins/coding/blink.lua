return {
    {
        "saghen/blink.cmp",
        branch = "v1",
        event = "VeryLazy",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {

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
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
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

                    -- Keep normal command-line cursor movement.
                    ["<Right>"] = false,
                    ["<Left>"] = false,

                    -- Cycle through candidates and update the inline preview.
                    ["<Tab>"] = {
                        "insert_next",
                        "fallback",
                    },

                    ["<S-Tab>"] = {
                        "insert_prev",
                        "fallback",
                    },

                    -- Accept the selected completion and execute the command.
                    ["<CR>"] = {
                        "accept_and_enter",
                        "fallback",
                    },

                    -- Accept without executing.
                    ["<C-y>"] = {
                        "accept",
                        "fallback",
                    },

                    -- Cancel the current completion.
                    ["<C-e>"] = {
                        "cancel",
                        "fallback",
                    },

                    -- Manually show completion when needed.
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
        },
    },
}
