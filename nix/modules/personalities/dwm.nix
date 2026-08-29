{inputs, ...}: {
	flake.modules.nixos.personality-dwm = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal dwm ly browser];
		terminal.default = "st";
		home-manager.sharedModules = [inputs.self.modules.homeManager.personality-dwm];
	};

	flake.modules.homeManager.personality-dwm = {
		# imports = with inputs.self.modules.homeManager; [i3 rofi];
		development.vscode.enable = true;
	};
}
