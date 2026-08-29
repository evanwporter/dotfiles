local M = {}
local projects = {}

local function project()
    local root = vim.fs.root(0, { "CMakeUserPresets.json", "CMakePresets.json", "CMakeLists.txt" })
    if not root then
        vim.notify("Not inside a CMake project", vim.log.levels.WARN)
        return nil
    end
    projects[root] = projects[root] or { root = root }
    return projects[root]
end

local function output(result)
    return vim.trim((result.stdout or "") .. (result.stderr or ""))
end

local function show_terminal(state, args, title, callback)
    vim.notify(title .. "…")
    if state.term_win and vim.api.nvim_win_is_valid(state.term_win) then
        vim.api.nvim_set_current_win(state.term_win)
        vim.cmd("enew")
    else
        vim.cmd("botright new")
        state.term_win = vim.api.nvim_get_current_win()
    end

    vim.api.nvim_win_set_height(state.term_win, math.max(8, math.floor(vim.o.lines * 0.30)))
    vim.wo[state.term_win].number = false
    vim.wo[state.term_win].relativenumber = false
    vim.wo[state.term_win].signcolumn = "no"

    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buflisted = false
    vim.bo[buf].bufhidden = "wipe"

    -- An argv list avoids shell-quoting bugs in paths, preset names, and targets.
    local job = vim.fn.jobstart(args, {
        cwd = state.root,
        term = true,
        on_exit = function(_, code)
            vim.schedule(function()
                local success = code == 0
                vim.notify(
                    title .. (success and " finished" or " failed"),
                    success and vim.log.levels.INFO or vim.log.levels.ERROR
                )
                if callback then
                    callback(success)
                end
            end)
        end,
    })
    if job <= 0 then
        vim.notify("Could not start " .. title, vim.log.levels.ERROR)
        if callback then
            callback(false)
        end
    end
end

local function configure_presets(state)
    local result = vim.system({ "cmake", "--list-presets=configure" }, { cwd = state.root, text = true }):wait()
    if result.code ~= 0 then
        vim.notify(output(result), vim.log.levels.ERROR)
        return {}
    end

    local choices = {}
    for line in (result.stdout or ""):gmatch("[^\n]+") do
        local name = line:match('^%s*"([^"]+)"')
        if name then
            choices[#choices + 1] = name
        end
    end
    return choices
end

local function choose(items, title, callback)
    if #items == 0 then
        vim.notify("No " .. title:lower() .. "s found", vim.log.levels.WARN)
        return
    end
    require("lazy").load({ plugins = { "fzf-lua" } })
    require("fzf-lua").fzf_exec(items, {
        prompt = "  ",
        winopts = {
            title = " " .. title .. " ",
            title_pos = "center",
            width = 0.45,
            height = math.floor(math.min(vim.o.lines * 0.6, #items + 4) + 0.5),
            preview = { hidden = "hidden" },
        },
        fzf_opts = { ["--layout"] = "reverse-list" },
        actions = {
            ["default"] = function(selected)
                if selected and selected[1] then
                    callback(selected[1])
                end
            end,
        },
    })
end

local function cache_home(cache)
    local file = io.open(cache, "r")
    if not file then
        return nil
    end
    for line in file:lines() do
        local home = line:match("^CMAKE_HOME_DIRECTORY:INTERNAL=(.*)$")
        if home then
            file:close()
            return vim.fs.normalize(home)
        end
    end
    file:close()
end

local function cache_snapshot(state)
    local caches = {}
    for _, cache in ipairs(vim.fs.find("CMakeCache.txt", { path = state.root, type = "file", limit = math.huge })) do
        if cache_home(cache) == vim.fs.normalize(state.root) then
            local stat = vim.uv.fs_stat(cache)
            if stat then
                caches[cache] = { sec = stat.mtime.sec, nsec = stat.mtime.nsec }
            end
        end
    end
    return caches
end

local function newer(left, right)
    return not right or left.sec > right.sec or (left.sec == right.sec and left.nsec > right.nsec)
end

local function find_build_dir(state, before)
    local newest_dir, newest_time
    for cache, time in pairs(cache_snapshot(state)) do
        local old = before and before[cache]
        local changed = not before or not old or old.sec ~= time.sec or old.nsec ~= time.nsec
        if changed and newer(time, newest_time) then
            newest_dir, newest_time = vim.fs.dirname(cache), time
        end
    end
    return newest_dir
end

function M.select_configuration()
    local state = project()
    if not state then
        return
    end
    choose(configure_presets(state), "CMake configure preset", function(preset)
        state.configure_preset = preset
        state.build_dir = nil
        state.needs_configure = true
        state.target = nil
        vim.notify("CMake configure preset: " .. preset)
    end)
end

function M.configure()
    local state = project()
    if not state then
        return
    end
    if not state.configure_preset then
        vim.notify("Select a configure preset first with \\cC", vim.log.levels.WARN)
        return
    end
    local caches_before = cache_snapshot(state)
    show_terminal(
        state,
        {
            "cmake",
            "--preset",
            state.configure_preset,
            "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
        },
        "CMake configure",
        function(success)
            if success then
                state.build_dir = find_build_dir(state, caches_before)
                if not state.build_dir then
                    vim.notify("Configured, but could not identify the preset's build directory", vim.log.levels.ERROR)
                    return
                end
                state.needs_configure = false
                vim.notify("CMake build directory: " .. state.build_dir)
            end
        end
    )
end

local function require_build_dir(state)
    if state.needs_configure then
        vim.notify("The selected preset has not been configured; run \\cc first", vim.log.levels.WARN)
        return false
    end
    state.build_dir = state.build_dir or find_build_dir(state)
    if not state.build_dir then
        vim.notify("Configure the project first with \\cc", vim.log.levels.WARN)
        return false
    end
    return true
end

function M.build()
    local state = project()
    if not state or not require_build_dir(state) then
        return
    end
    local args = { "cmake", "--build", state.build_dir }
    if state.target then
        vim.list_extend(args, { "--target", state.target })
    end
    show_terminal(state, args, "CMake build")
end

function M.select_target()
    local state = project()
    if not state or not require_build_dir(state) then
        return
    end
    local result = vim.system(
        { "cmake", "--build", state.build_dir, "--target", "help" },
        { cwd = state.root, text = true }
    )
        :wait()
    if result.code ~= 0 then
        vim.notify(output(result), vim.log.levels.ERROR)
        return
    end

    local targets, seen = {}, {}
    for line in (result.stdout or ""):gmatch("[^\n]+") do
        local target = line:match("^%.%.%. ([^%s]+)") or line:match("^([^:%s][^:]*)%s*:%s")
        if target and not seen[target] then
            seen[target] = true
            targets[#targets + 1] = target
        end
    end
    table.sort(targets)
    choose(targets, "CMake target", function(target)
        state.target = target
        vim.notify("CMake target: " .. target)
    end)
end

function M.setup()
    require("which-key").add({ { "<localleader>c", group = "CMake" } })
    vim.keymap.set("n", "<localleader>cc", M.configure, { desc = "CMake configure" })
    vim.keymap.set("n", "<localleader>cC", M.select_configuration, { desc = "CMake select configuration" })
    vim.keymap.set("n", "<localleader>cb", M.build, { desc = "CMake build" })
    vim.keymap.set("n", "<localleader>cB", M.select_target, { desc = "CMake select target" })
end

return M
