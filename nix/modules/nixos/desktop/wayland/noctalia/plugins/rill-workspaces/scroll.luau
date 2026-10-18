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
    local tiles = active.tiles
    if type(tiles) ~= "table" then
        tiles = {}
        for index = 1, active.windows do
            table.insert(tiles, { number = index, window = index, focused = active.focused_window == index })
        end
    end
    for _, tile in ipairs(tiles) do
        local index = tile.number
        local window = tile.window or index
        local focused = tile.focused
        table.insert(buttons, ui.button({
            key = "window-" .. tostring(active.number) .. "-" .. tostring(index),
            text = tostring(index),
            variant = focused and "primary" or "secondary",
            width = 30,
            height = 26,
            tooltip = "Focus column " .. tostring(index) .. (focused and " (focused)" or ""),
            onClick = function() command("focus-window", output, active, window) end,
        }))
    end
    barWidget.setTooltip(active.floating and "Floating windows" or "Click a column to scroll it into view")
    local container = barWidget.isVertical() and ui.column or ui.row
    barWidget.render(container({ gap = 4, align = "center" }, buttons))
end
