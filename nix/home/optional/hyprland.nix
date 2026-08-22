{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";
    settings = {};

    extraConfig = ''
      hl.config({
        input = {
          kb_layout = "gb",
        },
        xwayland = {
          force_zero_scaling = true,
        },
        general = {
          layout = "master",
          border_size = 2,
          gaps_in = 0,
          gaps_out = 0,
          col = {
            active_border = "rgba(ffffffff)",
            inactive_border = "rgba(1a1a1aff)",
          },
        },
        master = {
          orientation = "left",
          allow_small_split = true,
          mfact = 0.5,
        },
        decoration = {
          rounding = 5,
          rounding_power = 10,
          active_opacity = 1.0,
          inactive_opacity = 1.0,
          dim_special = 0.5,
          blur = { enabled = false },
          shadow = { enabled = false },
        },
        misc = {
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
          render_unfocused_fps = 1,
        },
      })

      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

      hl.on("hyprland.start", function()
        hl.exec_cmd("noctalia --daemon")
        hl.exec_cmd("sleep 1 && noctalia msg session lock")
      end)

      hl.window_rule({ match = { class = "^(thunar|Thunar)$", title = "Preferences" }, float = true, center = true, size = { 550, 500 } })
      hl.window_rule({ match = { class = "^(thunar|Thunar)$", title = "^(Rename.*)$" }, float = true, move = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" }, size = { 300, 100 } })
      hl.window_rule({ match = { class = "firefox", title = ".*Save.*" }, float = true, center = true })
      hl.window_rule({ match = { class = "firefox", title = ".*Open.*" }, float = true, center = true })
      hl.window_rule({ match = { class = "DesktopEditors" }, float = true, center = true })
      hl.window_rule({ match = { class = "xdg-desktop-portal-gtk", title = ".*Open.*" }, size = { "monitor_w * 0.5", "monitor_h * 0.5" }, float = true, center = true })
      hl.workspace_rule({ workspace = "special:scratchpad", layout = "scrolling", gaps_out = 40, gaps_in = 20 })

      hl.curve("fast", { type = "bezier", points = { { 0, 1 }, { 0, 1 } } })
      hl.curve("out", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
      hl.curve("in", { type = "bezier", points = { { 0, 1 }, { 1, 1 } } })

      hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "fast" })
      hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "fast", style = "slide" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "fast", style = "slide" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "out", style = "slide" })
      hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "fast" })
      hl.animation({ leaf = "fade", enabled = false })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "in", style = "slide" })
      hl.animation({ leaf = "layers", enabled = true, speed = 5, bezier = "fast", style = "slide" })
      hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "in", style = "slidefadevert 100%" })

      hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))
      hl.bind("SUPER + Q", hl.dsp.window.close())
      hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
      hl.bind("ALT + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher"))
      hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
      hl.bind("SUPER + D", hl.dsp.focus({ workspace = "empty" }))
      hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ workspace = "empty" }))
      hl.bind("SUPER + L", hl.dsp.exec_cmd("noctalia msg session lock"))
      hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
      hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
      hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
      hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "+1" }))
      hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "-1" }))
      hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "+1" }))
      hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "-1" }))
      hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))
      hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

      local function layout_bind(bind_table)
        return function()
          local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
          if not workspace then return end
          local layout = workspace.tiled_layout
          if bind_table[layout] then hl.dispatch(bind_table[layout]) end
        end
      end

      hl.bind("SUPER + comma", layout_bind({
        master = hl.dsp.layout("mfact -0.01"),
        scrolling = hl.dsp.layout("colresize -0.01"),
      }), { repeating = true })
      hl.bind("SUPER + period", layout_bind({
        master = hl.dsp.layout("mfact +0.01"),
        scrolling = hl.dsp.layout("colresize +0.01"),
      }), { repeating = true })
      hl.bind("SUPER + SHIFT + comma", layout_bind({
        master = hl.dsp.layout("orientationprev"),
        scrolling = hl.dsp.layout("swapcol l"),
      }))
      hl.bind("SUPER + SHIFT + period", layout_bind({
        master = hl.dsp.layout("orientationnext"),
        scrolling = hl.dsp.layout("swapcol r"),
      }))
      hl.bind("SUPER + slash", layout_bind({
        master = hl.dsp.layout("addmaster"),
        scrolling = hl.dsp.layout("consume"),
      }))
      hl.bind("SUPER + SHIFT + slash", layout_bind({
        master = hl.dsp.layout("removemaster"),
        scrolling = hl.dsp.layout("expel"),
      }))

      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"))
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"))
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"))
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"))
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"))
      hl.bind("XF86Display", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
      hl.bind("XF86NotificationCenter", hl.dsp.exec_cmd("noctalia msg power-cycle"))
      hl.bind("XF86PickupPhone", hl.dsp.exec_cmd("noctalia msg bluetooth-toggle"))
      hl.bind("XF86HangupPhone", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
      hl.bind("XF86Favorites", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
      hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))
      hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd("noctalia msg screenshot-region"))

      for workspace = 1, 9 do
        local name = tostring(workspace)
        hl.bind("SUPER + " .. name, hl.dsp.focus({ workspace = name }))
        hl.bind("SUPER + SHIFT + " .. name, hl.dsp.window.move({ workspace = name }))
      end

      for _, direction in ipairs({ "left", "right", "up", "down" }) do
        hl.bind("SUPER + " .. direction, hl.dsp.focus({ direction = direction }))
        hl.bind("SUPER + SHIFT + " .. direction, hl.dsp.window.move({ direction = direction }))
      end
    '';
  };
}
