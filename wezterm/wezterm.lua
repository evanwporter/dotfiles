local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = {
	"wsl.exe",
	"--cd",
	"~",
	"--exec",
	"/home/linuxbrew/.linuxbrew/bin/fish",
	"-l",
	"-c",
	"tmux new-session -A -s default",
}

config.enable_tab_bar = false

config.color_scheme = "Catppuccin Frappe"

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_close_confirmation = "NeverPrompt"

return config
