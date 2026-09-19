{
	flake.modules.homeManager.noctalia = {pkgs, ...}: {
		home.packages = [pkgs.noctalia];

		xdg.configFile = {
			"noctalia/config.toml".source = ./config.toml;
			"noctalia/tf2.jpg".source = ../resources/wallpaper/tf2.jpg;
		};

		# DriftWM (and other XDG-compliant desktops) launches these after its
		# Wayland session is ready. Keeping this here makes startup follow any
		# import of the Noctalia module, without compositor-specific wiring.
		xdg.configFile."autostart/noctalia.desktop".text = ''
			[Desktop Entry]
			Type=Application
			Name=Noctalia
			Exec=${pkgs.noctalia}/bin/noctalia -d
		'';
	};
}
