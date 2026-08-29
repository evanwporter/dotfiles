local spec_dir = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
local config_dir = vim.fs.normalize(spec_dir .. "/../../..")

return {
    -- {
    --     name = "cmake-tools",
    --     ft = "cmake",
    --     dir = config_dir .. "/plugins/cmake-tools",
    --     cond = not vim.g.vscode,
    --     dependencies = { "ibhagwan/fzf-lua" },
    --     lazy = true,
    --     init = function()
    --         local loaded = false
    --         local function load_in_cmake_project()
    --             if vim.fs.root(vim.uv.cwd(), { "CMakeUserPresets.json", "CMakePresets.json", "CMakeLists.txt" }) then
    --                 require("lazy").load({ plugins = { "cmake-tools" } })
    --                 loaded = true
    --             end
    --         end
    --
    --         load_in_cmake_project()
    --         vim.api.nvim_create_autocmd("DirChanged", {
    --             callback = function()
    --                 if not loaded then
    --                     load_in_cmake_project()
    --                 end
    --             end,
    --         })
    --     end,
    --     config = function()
    --         require("cmake-tools").setup()
    --     end,
    -- },
    {
        "Civitasv/cmake-tools.nvim",
        cond = not vim.g.vscode,
        lazy = true,
        init = function()
            local loaded = false
            local function check()
                local cwd = vim.uv.cwd()
                if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
                    require("lazy").load({ plugins = { "cmake-tools.nvim" } })
                    loaded = true
                end
            end
            check()
            vim.api.nvim_create_autocmd("DirChanged", {
                callback = function()
                    if not loaded then
                        check()
                    end
                end,
            })
        end,
        opts = {
            cmake_command = "cmake",
            ctest_command = "ctest",
            cmake_use_preset = true,
            cmake_regenerate_on_save = true,

            cmake_generate_options = {
                "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
            },

            cmake_build_directory = "build/${variant:buildType}",

            cmake_compile_commands_options = {
                action = "soft_link",
                target = vim.fn.getcwd(),
            },

            cmake_executor = {
                name = "quickfix",
                opts = {
                    show = "always",
                    -- auto_close_when_success = false,
                },
            },

            cmake_runner = {
                name = "terminal",
                opts = {},
            },

            cmake_dap_configuration = {
                name = "cpp",
                type = "codelldb",
                request = "launch",
                stopOnEntry = false,
                runInTerminal = true,
                console = "integratedTerminal",
            },
        },
        config = function(_, opts)
            require("cmake-tools").setup(opts)

            require("which-key").add({
                { "<localleader>c", group = "CMake" },
            })

            vim.keymap.set("n", "<localleader>cb", "<cmd>CMakeBuild<cr>", { desc = "Build" })
            vim.keymap.set("n", "<localleader>cc", "<cmd>CMakeSelectConfigurePreset<cr>", { desc = "Configure Preset" })
            vim.keymap.set("n", "<localleader>cB", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "Build Target" })
        end,
    },
}
