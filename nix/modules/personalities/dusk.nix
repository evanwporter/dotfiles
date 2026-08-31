{inputs, ...}: {
	flake.modules.nixos.personality-dusk = {
		imports = with inputs.self.modules.nixos; [system-desktop terminal dusk ly browser];
		terminal.default = "kitty";
		services.xserver.windowManager.dusk.enable = true;
		home-manager.sharedModules = [inputs.self.modules.homeManager.personality-dusk];
	};

	# Dusk shares the X11 desktop helpers that were previously grouped under the
	# DWM personality (cursor and touchpad gesture setup).
	flake.modules.homeManager.personality-dusk = {
		imports = with inputs.self.modules.homeManager; [dwm];
		development.vscode.enable = true;
	};
}
