{...}: {
	flake.modules.homeManager.sway = {
		lib,
		osConfig ? null,
		...
	}: {
		xdg.configFile =
			lib.mkIf (osConfig != null && osConfig.programs.sway.enable) {
				"sway/config".source = ./sway.config;
				"sway/tf2.jpg".source = ../resources/wallpaper/wp.png;
			};
	};
}
