vim.notify = function(msg, log_level, opts)
    log_level = log_level or vim.log.levels.INFO
    opts = opts or {}

    local source = opts.title
    if not source then
        source = "System"
        for i = 2, 6 do
            local info = debug.getinfo(i, "S")
            if info and info.source and info.source:match(".*[/\\]lua[/\\](.*)%.lua") then
                local module_path = info.source:match(".*[/\\]lua[/\\](.*)%.lua")
                if module_path and not module_path:match("^vim%.") then
                    source = module_path:match("^([^/\\]+)") or module_path
                    break
                end
            end
        end
    end

    local level_map = {
        [vim.log.levels.TRACE] = { prefix = "Trace", hl = "DiagnosticHint" },
        [vim.log.levels.DEBUG] = { prefix = "Debug", hl = "DiagnosticHint" },
        [vim.log.levels.INFO] = { prefix = "Info", hl = "DiagnosticInfo" },
        [vim.log.levels.WARN] = { prefix = "Warn", hl = "DiagnosticWarn" },
        [vim.log.levels.ERROR] = { prefix = "Error", hl = "DiagnosticError" },
    }

    local config = level_map[log_level] or { prefix = "Notice", hl = "Normal" }

    local chunks = {
        { string.format("[%s] ", source), "Title" },
        { config.prefix .. ": ", config.hl },
        { msg, "Normal" },
    }

    vim.api.nvim_echo(chunks, true, {})
end
