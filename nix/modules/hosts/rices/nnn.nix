# NixOS + Noctalia + Niri
{inputs, ...}: {
	flake.modules.nixos.nnn-rice = {
		imports = with inputs.self.modules.nixos; [
			system-desktop
			terminal
			niri
			# mango
			# niri
			# dusk
			# dwl
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
