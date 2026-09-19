{inputs, ...}: {
	flake.modules.nixos.personality-driftwm = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal driftwm ly browser];
		terminal.default = "kitty";
		home-manager.sharedModules = [inputs.self.modules.homeManager.personality-driftwm];
	};

	flake.modules.homeManager.personality-driftwm = {
		imports = with inputs.self.modules.homeManager; [driftwm noctalia];
	};
}
