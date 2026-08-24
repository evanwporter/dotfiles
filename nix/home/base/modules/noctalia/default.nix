{
	lib,
	osConfig ? null,
	...
}: {
	xdg.configFile =
		lib.mkIf (osConfig != null && osConfig.programs.noctalia.enable) {
			"noctalia/config.toml".source = ./config.toml;
			"noctalia/tf2.jpg".source = ../resources/wallpaper/tf2.jpg;
		};
}
