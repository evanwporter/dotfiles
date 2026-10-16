{inputs, ...}: {
	flake.modules.homeManager.x11 = {pkgs, ...}: {
		imports = with inputs.self.modules.homeManager; [dunst];

		xdg.configFile."libinput-gestures.conf".source = ./libinput-gestures.conf;

		xdg.configFile."flameshot/flameshot.ini" = {
			force = true;
			text = ''
				[General]
				useX11LegacyScreenshot=true
			'';
		};

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
	};
}
