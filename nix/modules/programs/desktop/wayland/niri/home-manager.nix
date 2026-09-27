{inputs, ...}: {
	flake.modules.homeManager.niri = {
		imports = with inputs.self.modules.homeManager; [noctalia];
		xdg.configFile = {
			"niri/config.kdl".source = ./user.kdl;
			"niri/tf2.jpg".source = ../resources/wallpaper/tf2.jpg;
		};
	};
}
