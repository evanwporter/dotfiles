return {
    {
        "mfussenegger/nvim-dap",
        enabled = false,
        dependencies = {
            "ibhagwan/fzf-lua",
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
            "nvim-lua/plenary.nvim",
        },

    -- stylua: ignore
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },

      -- fzf-lua DAP helpers
      { "<leader>dC", function() require("fzf-lua").dap_configurations() end, desc = "DAP Configurations" },
      { "<leader>dB", function() require("fzf-lua").dap_breakpoints() end, desc = "DAP Breakpoints" },
      { "<leader>df", function() require("fzf-lua").dap_frames() end, desc = "DAP Frames" },
      { "<leader>dv", function() require("fzf-lua").dap_variables() end, desc = "DAP Variables" },
      { "<leader>dx", function() require("fzf-lua").dap_commands() end, desc = "DAP Commands" },
    },

        config = function()
            local dap = require("dap")
            local uv = vim.uv or vim.loop

            local function warn(msg)
                vim.notify(msg, vim.log.levels.WARN, { title = "nvim-dap" })
            end

            local function dap_pick_exec()
                local fzf = require("fzf-lua")

                return coroutine.create(function(dap_co)
                    local function dap_abort()
                        coroutine.resume(dap_co, dap.ABORT)
                    end

                    local function dap_run(exec)
                        if type(exec) == "string" and exec ~= "" and vim.fn.executable(exec) == 1 then
                            coroutine.resume(dap_co, exec)
                        else
                            if exec ~= nil and exec ~= "" then
                                warn(string.format("'%s' is not executable, aborting.", exec))
                            end
                            dap_abort()
                        end
                    end

                    fzf.files({
                        cwd = uv.cwd(),
                        git_icons = false,
                        cmd = "fd --color=never --no-ignore --type x --hidden --follow --exclude .git",
                        header = (":: %s to execute prompt"):format(fzf.utils.ansi_codes["yellow"]("<Ctrl-e>")),
                        winopts = {
                            width = 0.65,
                            height = 0.45,
                            preview = { hidden = "hidden" },
                            title = { { " DAP: Select Executable to Debug ", "Cursor" } },
                            title_pos = "center",
                        },
                        actions = {
                            ["esc"] = dap_abort,
                            ["ctrl-c"] = dap_abort,
                            ["ctrl-g"] = false,

                            ["ctrl-e"] = function(_, opts)
                                dap_run(opts.last_query)
                            end,

                            ["default"] = function(sel)
                                if not sel or not sel[1] then
                                    dap_abort()
                                    return
                                end

                                local file = fzf.path.entry_to_file(sel[1])
                                dap_run(file.path)
                            end,
                        },
                    })
                end)
            end

            local function dap_pick_process(fzflua_opts, getproc_opts)
                local fzf = require("fzf-lua")

                return coroutine.create(function(dap_co)
                    local function dap_abort()
                        coroutine.resume(dap_co, dap.ABORT)
                    end

                    local procs = require("dap.utils").get_processes(getproc_opts)

                    fzf.fzf_exec(
                        function(fzf_cb)
                            for _, p in ipairs(procs) do
                                fzf_cb(string.format("[%d] %s", p.pid, p.name))
                            end
                        end,
                        vim.tbl_deep_extend("force", {
                            winopts = {
                                width = 0.65,
                                height = 0.45,
                                preview = { hidden = "hidden" },
                                title = { { " DAP: Select Process to Debug ", "Cursor" } },
                                title_pos = "center",
                            },
                            actions = {
                                ["esc"] = dap_abort,
                                ["ctrl-c"] = dap_abort,

                                ["default"] = function(sel)
                                    if not sel or not sel[1] then
                                        dap_abort()
                                        return
                                    end

                                    local pid = tonumber(sel[1]:match("^%[(%d+)%]"))
                                    if pid then
                                        coroutine.resume(dap_co, pid)
                                    else
                                        dap_abort()
                                    end
                                end,
                            },
                        }, fzflua_opts or {})
                    )
                end)
            end

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = assert(vim.env.CODELLDB_PATH, "CODELLDB_PATH is not set"),
                    args = { "--port", "${port}" },
                },
            }

            if vim.fn.has("win32") == 1 then
                dap.adapters.codelldb.executable.detached = false
            end

            for _, lang in ipairs({ "c", "cpp", "rust" }) do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "launch",
                        name = "Launch executable",
                        program = dap_pick_exec,
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                    },
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        pid = dap_pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            require("dap.ext.vscode").load_launchjs(nil, {
                codelldb = { "c", "cpp", "rust" },
            })

            -- Python debugging configurations
            -- Note: adapter is automatically configured by mason-nvim-dap
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                            return cwd .. "/venv/bin/python"
                        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                            return cwd .. "/.venv/bin/python"
                        else
                            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
                        end
                    end,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file with arguments",
                    program = "${file}",
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.split(args_string, " +")
                    end,
                    pythonPath = function()
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                            return cwd .. "/venv/bin/python"
                        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                            return cwd .. "/.venv/bin/python"
                        else
                            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
                        end
                    end,
                },
                {
                    type = "python",
                    request = "attach",
                    name = "Attach remote",
                    connect = function()
                        local host = vim.fn.input("Host [127.0.0.1]: ")
                        host = host ~= "" and host or "127.0.0.1"
                        local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
                        return { host = host, port = port }
                    end,
                },
            }
        end,
    },

    -- nvim-dap-ui: VSCode-like debug interface
    -- Uncomment this and comment out nvim-dap-view to use it
    -- {
    --     "rcarriga/nvim-dap-ui",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --         "nvim-neotest/nvim-nio",
    --     },
    --
    --     -- stylua: ignore
    --     keys = {
    --       { "<leader>dd", function() require("dapui").toggle({}) end, desc = "Dap UI" },
    --       { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "x" } },
    --     },
    --
    --     opts = {},
    --
    --     config = function(_, opts)
    --         local dap = require("dap")
    --         local dapui = require("dapui")
    --
    --         dapui.setup(opts)
    --
    --         dap.listeners.after.event_initialized["dapui_config"] = function()
    --             dapui.open({})
    --         end
    --
    --         dap.listeners.before.event_terminated["dapui_config"] = nil
    --         dap.listeners.before.event_exited["dapui_config"] = nil
    --     end,
    -- },

    -- nvim-dap-view: Minimalist debug interface
    -- Uncomment this and comment out nvim-dap-ui to use it
    {
        "igorlfs/nvim-dap-view",
        enabled = false,
        version = "1.*",
        dependencies = {
            "mfussenegger/nvim-dap",
        },

        -- stylua: ignore
        keys = {
          { "<leader>dd", function() require("dap-view").toggle(true) end, desc = "Dap View" },
          { "<leader>de", function() require("dap-view").hover(nil, true) end, desc = "Eval", mode = { "n", "x" } },
        },

        opts = {
            windows = {
                size = 0.5,
                position = "below",
                terminal = {
                    size = 0.5,
                    position = "left",
                    hide = {},
                },
            },
            winbar = {
                show = true,
                sections = {
                    "watches",
                    "scopes",
                    "exceptions",
                    "breakpoints",
                    -- "threads",
                    "repl",
                },
                default_section = "scopes",
                show_keymap_hints = false,
                controls = {
                    enabled = true,
                    position = "right",
                },
            },
        },

        config = function(_, opts)
            local dap = require("dap")
            local dapview = require("dap-view")

            dapview.setup(opts)

            dap.listeners.after.event_initialized["dap_view_config"] = function()
                dapview.open()
            end
        end,
    },
}
