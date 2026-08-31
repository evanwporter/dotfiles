{inputs, ...}: {
	flake.modules.homeManager.dwm = {pkgs, ...}: {
		imports = [inputs.self.modules.homeManager.cursor];

		xdg.configFile."libinput-gestures.conf".source = ./libinput-gestures.conf;

		systemd.user.services.libinput-gestures = {
			Unit = {
				Description = "Touchpad gesture recognition";
				PartOf = ["graphical-session.target"];
			};
			Service = {
				ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures -c %h/.config/libinput-gestures.conf";
				Restart = "on-failure";
			};
			Install.WantedBy = ["graphical-session.target"];
		};

		# https://github.com/nix-community/home-manager/issues/9201#issuecomment-4457618997
		# services.flameshot = {
		# 	enable = true;
		# 	settings = {
		# 		General.useX11LegacyScreenshot = true; # necessary to avoid "portal" issues on XMonad
		# 	};
		# };
		# xdg.configFile."flameshot/flameshot.ini".force = true;
	};
}
