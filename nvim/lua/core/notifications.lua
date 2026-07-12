vim.notify = function(msg, log_level, opts)
    log_level = log_level or vim.log.levels.INFO

    -- TOGGLE ICONS HERE: Set to true to show symbols, or false to hide them completely
    local use_icons = false

    -- 1. Scan the call stack to find who called this function
    local source_name = "System"
    for i = 2, 6 do
        local info = debug.getinfo(i, "S")
        if info and info.source and info.source:match(".*[/\\]lua[/\\](.*)%.lua") then
            local module_path = info.source:match(".*[/\\]lua[/\\](.*)%.lua")
            if module_path and not module_path:match("^vim%.") then
                source_name = module_path:match("^([^/\\]+)") or module_path
                break
            end
        end
    end

    -- 2. Configuration maps (Icons separated from layout metadata)
    local level_map = {
        [vim.log.levels.TRACE] = { prefix = "Trace", hl = "DiagnosticHint" },
        [vim.log.levels.DEBUG] = { prefix = "Debug", hl = "DiagnosticHint" },
        [vim.log.levels.INFO] = { prefix = "Info", hl = "DiagnosticInfo" },
        [vim.log.levels.WARN] = { prefix = "Warn", hl = "DiagnosticWarn" },
        [vim.log.levels.ERROR] = { prefix = "Error", hl = "DiagnosticError" },
    }

    local icon_map = {
        [vim.log.levels.TRACE] = "✎",
        [vim.log.levels.DEBUG] = "",
        [vim.log.levels.INFO] = "",
        [vim.log.levels.WARN] = "",
        [vim.log.levels.ERROR] = "",
    }

    local config = level_map[log_level] or { prefix = "Notice", hl = "Normal" }
    local icon = use_icons and (icon_map[log_level] or "") or ""

    -- 3. Build out the display chunks dynamically
    local chunks = {}
    table.insert(chunks, { string.format("[%s] ", source_name), "Title" })

    -- Insert the icon chunk only if use_icons is active and an icon exists
    if use_icons and icon ~= "" then
        table.insert(chunks, { icon .. " ", config.hl })
    end

    table.insert(chunks, { config.prefix .. ": ", config.hl })
    table.insert(chunks, { msg, "Normal" })

    -- 4. Print out the final structured notification
    vim.api.nvim_echo(chunks, true, {})
end
