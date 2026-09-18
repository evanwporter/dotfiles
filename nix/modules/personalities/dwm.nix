{inputs, ...}: {
	flake.modules.nixos.personality-dwm = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal x11 dwm ly browser xmonad];
		terminal.default = "st";
		home-manager.sharedModules = [inputs.self.modules.homeManager.personality-dwm];
	};

	flake.modules.homeManager.personality-dwm = {
		imports = with inputs.self.modules.homeManager; [dwm eww vscode zed helix];
	};
}
