return {
    {
        "Civitasv/cmake-tools.nvim",
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
        ---@module "cmake-tools"
        ---@type cmake-tools.Config
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
    },
}
