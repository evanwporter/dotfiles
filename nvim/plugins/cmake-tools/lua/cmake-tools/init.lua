local M = {}
local projects = {}

local function project()
    local root = vim.fs.root(0, { "CMakeUserPresets.json", "CMakePresets.json", "CMakeLists.txt" })
    if not root then
        vim.notify("Not inside a CMake project", vim.log.levels.WARN)
        return
    end
    projects[root] = projects[root] or { root = root }
    return projects[root]
end

local function output_lines(result)
    return vim.split((result.stdout or "") .. (result.stderr or ""), "\n", { trimempty = true })
end

local function run(state, args, title, callback)
    vim.notify(title .. "…")
    vim.system(args, { cwd = state.root, text = true }, function(result)
        vim.schedule(function()
            local lines = output_lines(result)
            vim.fn.setqflist({}, " ", { title = title, lines = lines })
            if result.code == 0 then
                vim.notify(title .. " finished")
            else
                vim.cmd.copen()
                vim.notify(title .. " failed", vim.log.levels.ERROR)
            end
            if callback then
                callback(result.code == 0, result)
            end
        end)
    end)
end

local function presets(state, kind)
    local result = vim.system({ "cmake", "--list-presets=" .. kind }, { cwd = state.root, text = true }):wait()
    if result.code ~= 0 then
        vim.notify(table.concat(output_lines(result), "\n"), vim.log.levels.ERROR)
        return {}
    end

    local choices = {}
    for line in (result.stdout or ""):gmatch("[^\n]+") do
        local name = line:match('^%s*"([^"]+)"')
        if name then
            table.insert(choices, name)
        end
    end
    return choices
end

local function select_preset(state, kind, callback)
    local choices = presets(state, kind)
    if #choices == 0 then
        callback(nil)
        return
    end

    require("lazy").load({ plugins = { "fzf-lua" } })
    require("fzf-lua").fzf_exec(choices, {
        prompt = "  ",
        winopts = {
            title = " CMake " .. kind .. " preset ",
            title_pos = "center",
            width = 0.35,
            height = math.floor(math.min(vim.o.lines * 0.6, #choices + 4) + 0.5),
            preview = { hidden = "hidden" },
        },
        fzf_opts = { ["--layout"] = "reverse-list" },
        actions = {
            ["default"] = function(selected)
                local choice = selected and selected[1]
                if choice then
                    state[kind .. "_preset"] = choice
                    vim.notify("CMake " .. kind .. " preset: " .. choice)
                end
                callback(choice)
            end,
        },
    })
end

local function configure_project(state, callback)
    local function execute(preset)
        local args = preset and { "cmake", "--preset", preset, "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" }
            or { "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" }
        run(state, args, "CMake configure", function(success, result)
            state.configured = success
            if success then
                local output = (result.stdout or "") .. (result.stderr or "")
                state.build_dir = output:match("Build files have been written to:%s*([^\n]+)") or state.build_dir or "build"
            end
            if callback then
                callback(success)
            end
        end)
    end

    if state.configure_preset then
        execute(state.configure_preset)
    else
        select_preset(state, "configure", execute)
    end
end

local function build_project(state)
    local function execute()
        local args = { "cmake", "--build", state.build_dir or "build" }
        if state.target then
            vim.list_extend(args, { "--target", state.target })
        end
        run(state, args, "CMake build")
    end

    if state.configured then
        execute()
    else
        configure_project(state, function(success)
            if success then
                execute()
            end
        end)
    end
end

function M.configure()
    local state = project()
    if state then
        configure_project(state)
    end
end

function M.build()
    local state = project()
    if state then
        build_project(state)
    end
end

function M.select_configuration()
    local state = project()
    if not state then
        return
    end
    select_preset(state, "configure", function(choice)
        if choice then
            state.configured = false
        end
    end)
end

function M.select_target()
    local state = project()
    if not state then
        return
    end

    local function select()
        local result = vim.system(
            { "cmake", "--build", state.build_dir or "build", "--target", "help" },
            { cwd = state.root, text = true }
        ):wait()
        if result.code ~= 0 then
            vim.notify(table.concat(output_lines(result), "\n"), vim.log.levels.ERROR)
            return
        end

        local targets, seen = {}, {}
        for _, line in ipairs(output_lines(result)) do
            local target = line:match("^%.%.%. ([^%s]+)") or line:match("^([^:%s][^:]*)%s*:%s")
            if target and not seen[target] then
                seen[target] = true
                table.insert(targets, target)
            end
        end
        require("lazy").load({ plugins = { "fzf-lua" } })
        require("fzf-lua").fzf_exec(targets, {
            prompt = "  ",
            winopts = { title = " CMake target ", title_pos = "center", preview = { hidden = "hidden" } },
            actions = {
                ["default"] = function(selected)
                    state.target = selected and selected[1]
                    if state.target then
                        vim.notify("CMake target: " .. state.target)
                    end
                end,
            },
        })
    end

    if state.configured then
        select()
    else
        configure_project(state, function(success)
            if success then
                select()
            end
        end)
    end
end

function M.setup()
    local group = vim.api.nvim_create_augroup("cmake_tools", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        pattern = { "CMakeLists.txt", "*.cmake" },
        callback = M.configure,
    })

    require("which-key").add({ { "<localleader>c", group = "CMake" } })
    vim.keymap.set("n", "<localleader>cb", function()
        require("cmake-tools").build()
    end, { desc = "CMake build" })
    vim.keymap.set("n", "<localleader>cc", function()
        require("cmake-tools").configure()
    end, { desc = "CMake configure" })
    vim.keymap.set("n", "<localleader>cB", function()
        require("cmake-tools").select_target()
    end, { desc = "CMake select target" })
    vim.keymap.set("n", "<localleader>cC", function()
        require("cmake-tools").select_configuration()
    end, { desc = "CMake select configuration" })
end

return M
