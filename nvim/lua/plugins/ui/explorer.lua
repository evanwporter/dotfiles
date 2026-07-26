return {
    {
        "evanwporter/nvim-tree.lua",
        enabled = false,
        dependencies = {
            {
                "nvim-mini/mini.icons",
                opts = {
                    extension = {
                        j2 = { glyph = "󰅩", hl = "MiniIconsYellow" },
                    },
                },
                init = function()
                    package.preload["nvim-web-devicons"] = function()
                        require("mini.icons").mock_nvim_web_devicons()
                        return package.loaded["nvim-web-devicons"]
                    end
                end,
            },
        },

        keys = {
            {
                "<leader>e",
                function()
                    require("nvim-tree.api").tree.toggle({
                        path = vim.fn.getcwd(),
                        focus = true,
                    })
                end,
                desc = "Explorer",
            },
        },

        opts = {
            disable_netrw = true,
            hijack_netrw = true,

            sync_root_with_cwd = true,
            respect_buf_cwd = true,

            view = {
                side = "left",
                width = 32,
                number = true,
                relativenumber = true,
            },

            renderer = {
                group_empty = true,
                icons = {
                    git_placement = "right_align",

                    glyphs = {
                        git = {
                            unstaged = "●",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },

                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
            },

            filters = {
                dotfiles = false,
                git_ignored = true,
                custom = {
                    "^\\.git$",
                    "^\\.DS_Store$",
                },
                exclude = { "build" },
            },

            git = {
                enable = false,
                ignore = false,
            },

            diagnostics = {
                enable = false,
                show_on_dirs = true,
            },

            update_focused_file = {
                enable = true,
                update_root = false,
            },

            filesystem_watchers = {
                enable = true,
            },

            actions = {
                open_file = {
                    quit_on_open = false,
                },
            },

            ui = {
                confirm = {
                    default_yes = true,
                },
            },

            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,

                        nowait = true,
                    }
                end

                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.set("n", "<space>", "<Nop>", opts("Disable Space"))
                vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
                vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
                vim.keymap.set("n", "a", api.fs.create, opts("Create"))
                vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
                vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
                vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
                vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
                vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
                vim.keymap.set("n", "q", api.tree.close, opts("Close"))
                vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
            end,
        },
    },
}
