{
	flake.modules.homeManager.noctalia = {pkgs, ...}: {
		home.packages = [pkgs.noctalia];

		xdg.configFile = {
			"noctalia/config.toml".source = ./config.toml;
			"noctalia/tf2.jpg".source = ../../resources/wallpaper/tf2.jpg;
		};
	};
}
