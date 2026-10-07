{
	flake.modules.homeManager.niri = {
		xdg.configFile = {
			"niri/config.kdl".source = ./user.kdl;
			"niri/tf2.jpg".source = ../resources/wallpaper/tf2.jpg;
		};
	};
}
