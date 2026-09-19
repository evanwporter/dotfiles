{
	flake.modules.nixos.picom = {
		services.picom = {
			enable = true;
			backend = "glx";
			vSync = true;
		};
	};

	flake.modules.homeManager.picom = {
		xdg.configFile."picom/picom.conf".source = ./picom.conf;
	};
}
