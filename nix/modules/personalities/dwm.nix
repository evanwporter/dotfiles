{inputs, ...}: {
	flake.modules.nixos.personality-dwm = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal dwm ly browser];
		terminal.default = "kitty";
		home-manager.sharedModules = [inputs.self.modules.homeManager.personality-dwm];
	};

	flake.modules.homeManager.personality-dwm = {
		imports = with inputs.self.modules.homeManager; [dwm];
		development.vscode.enable = true;
	};
}
