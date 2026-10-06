{inputs, ...}: {
	flake.modules.homeManager.graphical = {
		imports = with inputs.self.modules.homeManager; [
			obsidian
			spotify
			zathura
		];
	};
}
