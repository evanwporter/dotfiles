{...}: {
	flake.modules.homeManager.niri = {
		lib,
		osConfig ? null,
		...
	}: {
		xdg.configFile =
			lib.mkIf (osConfig != null && osConfig.programs.niri.enable) {
				"niri/config.kdl".source = ./user.kdl;
				"niri/tf2.jpg".source = ../resources/wallpaper/tf2.jpg;
			};
	};
}
