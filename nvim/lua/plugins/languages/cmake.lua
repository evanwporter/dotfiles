-- CMake tools
-- Installation handled by lua/sources.lua

return {
    "cmake-tools.nvim",
    lazy = true,
    ft = { "c", "cpp", "cmake" },
    after = function()
        require("cmake-tools").setup({
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
        })
    end,
}
