{inputs, ...}: {
	flake.modules.nixos.personality-dwl = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal dwl browser x11 dwm st];
		terminal.default = "kitty";
		home-manager.sharedModules = [inputs.self.modules.homeManager.personality-dwl];
	};

	flake.modules.homeManager.personality-dwl = {};
}
