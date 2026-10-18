-- Rill publishes one status file and command socket per Wayland session.
local function command(verb, output, workspace, window)
    local argv = { noctalia.expandPath("~/rill/zig-out/bin/rill"), "msg", verb,
        tostring(output.index), tostring(workspace.number) }
    if window then table.insert(argv, tostring(window)) end
    noctalia.runAsync(argv, function(result)
        if result.exitCode ~= 0 then
            noctalia.notify("Rill", "Window buttons need the updated Rill session. Log out and back in.")
            noctalia.log(result.stderr)
        end
    end)
end

local function state()
    local runtime = noctalia.getenv("XDG_RUNTIME_DIR")
    local display = noctalia.getenv("WAYLAND_DISPLAY") or "wayland-0"
    if not runtime or string.find(display, "/", 1, true) then return nil end
    local contents = noctalia.readFile(runtime .. "/rill-" .. display .. "-workspaces.json")
    if not contents then return nil end
    local ok, data = pcall(noctalia.json.decode, contents)
    if not ok or type(data) ~= "table" or type(data.outputs) ~= "table" then return nil end
    for _, output in ipairs(data.outputs) do
        if output.focused then
            for _, workspace in ipairs(output.workspaces) do
                if workspace.active then return output, workspace end
            end
        end
    end
    return nil
end

function update()
    noctalia.setUpdateInterval(100)
    local output, active = state()
    if not output then
        barWidget.render(ui.label({ text = "" }))
        barWidget.clearTooltip()
        return
    end
    local buttons = {}
    for _, workspace in ipairs(output.workspaces) do
        table.insert(buttons, ui.button({
            key = "workspace-" .. tostring(workspace.number),
            text = tostring(workspace.number) .. (workspace.windows > 0 and "•" or ""),
            variant = workspace.active and "primary" or "ghost",
            height = 26,
            tooltip = "Workspace " .. tostring(workspace.number),
            onClick = function() command("focus-workspace", output, workspace) end,
        }))
    end
    barWidget.setTooltip("Rill workspaces")
    local container = barWidget.isVertical() and ui.column or ui.row
    barWidget.render(container({ gap = 4, align = "center" }, buttons))
end
