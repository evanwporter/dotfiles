return {
    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = false,
            },
            panel = {
                enabled = false,
            },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },

    {
        "saghen/blink.cmp",
        branch = "v1",

        dependencies = {
            "rafamadriz/friendly-snippets",
            -- "fang2hou/blink-copilot",
        },

        opts = {
            snippets = {
                preset = "default",
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    -- "copilot",
                },

                -- providers = {
                --   copilot = {
                --     name = "copilot",
                --     module = "blink-copilot",
                --     score_offset = 100,
                --     async = true,
                --   },
                -- },
            },

            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
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

                    ["<Down>"] = {
                        "insert_next",
                        "fallback",
                    },

                    ["<Up>"] = {
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
