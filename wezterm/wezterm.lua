local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = {
	"wsl.exe",
	"-d",
	"NixOS",
	"--cd",
	"~",
	"-e",
	"/run/current-system/sw/bin/fish",
	"-l",
	"-c",
	"/run/current-system/sw/bin/tmux",
	"new-session",
	"-A",
	"-s default",
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

config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono NFM", weight = "Regular", style = "Normal" },
	"Symbols Nerd Font Mono",
	"Noto Color Emoji",
})

config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font_with_fallback({
			{ family = "JetBrainsMono NFM", weight = "Bold", style = "Normal" },
			"Symbols Nerd Font Mono",
			"Noto Color Emoji",
		}),
	},
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "JetBrainsMono NFM", weight = "Regular", style = "Italic" },
			"Symbols Nerd Font Mono",
			"Noto Color Emoji",
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "JetBrainsMono NFM", weight = "Bold", style = "Italic" },
			"Symbols Nerd Font Mono",
			"Noto Color Emoji",
		}),
	},
}

config.window_close_confirmation = "NeverPrompt"

return config
