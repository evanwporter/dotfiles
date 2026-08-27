local spec_dir = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
local config_dir = vim.fs.normalize(spec_dir .. "/../../..")

return {
    {
        name = "cmake-tools",
        ft = "cmake",
        dir = config_dir .. "/plugins/cmake-tools",
        cond = not vim.g.vscode,
        dependencies = { "ibhagwan/fzf-lua" },
        lazy = true,
        init = function()
            local loaded = false
            local function load_in_cmake_project()
                if vim.fn.filereadable(vim.uv.cwd() .. "/CMakeLists.txt") == 1 then
                    require("lazy").load({ plugins = { "cmake-tools" } })
                    loaded = true
                end
            end

            load_in_cmake_project()
            vim.api.nvim_create_autocmd("DirChanged", {
                callback = function()
                    if not loaded then
                        load_in_cmake_project()
                    end
                end,
            })
        end,
        config = function()
            require("cmake-tools").setup()
        end,
    },
}
