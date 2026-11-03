{inputs, ...}: {
	flake.modules.nixos.personality-kde = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal kde browser];
		terminal.default = "kitty";
		# home-manager.sharedModules = [inputs.self.modules.homeManager.personality-dwm];
	};
}
