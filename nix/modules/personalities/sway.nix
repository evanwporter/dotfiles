{inputs, ...}: {
	flake.modules.nixos.personality-sway = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal sway ly browser];
		terminal.default = "kitty";
		home-manager.sharedModules = with inputs.self.modules.homeManager; [
			# TODO: This should be moved elsewhere
			personality-sway
			sway
		];
	};

	flake.modules.homeManager.personality-sway = {
		# imports = with inputs.self.modules.homeManager; [];
		development.vscode.enable = true;
	};
}
