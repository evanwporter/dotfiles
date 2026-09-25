{inputs, ...}: {
	flake.modules.nixos.personality-x11 = {
		imports = with inputs.self.modules.nixos; [
			system-desktop
			terminal
			x11
			dwm
			ly
			browser
			# dwl
			# ewm
			# xmonad
			# bspwm
		];
		terminal.default = "st";
		# home-manager.sharedModules = [inputs.self.modules.homeManager.personality-x11];
	};

	# flake.modules.homeManager.personality-x11 = {
	# 	imports = with inputs.self.modules.homeManager; [
	# 		# dwm
	# 		# eww
	# 		# picom
	# 	];
	# };
}
