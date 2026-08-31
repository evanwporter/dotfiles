{inputs, ...}: {
	flake.modules.homeManager.dwm = {pkgs, ...}: {
		imports = with inputs.self.modules.homeManager; [cursor dunst];

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

		# Flameshot v14 defaults to the desktop portal even on X11.  Minimal
		# window managers have no screenshot-capable portal backend, so use its
		# built-in X11 capture implementation instead.
		# Replace the empty configuration file left by Flameshot itself.  This does
		# not start the tray daemon; the Print-key binding launches `flameshot gui`
		# only when a screenshot is requested.
		xdg.configFile."flameshot/flameshot.ini" = {
			force = true;
			text = ''
				[General]
				useX11LegacyScreenshot=true
			'';
		};
	};
}
