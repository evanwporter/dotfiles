{inputs, ...}: {
	flake.modules.homeManager.graphical = {
		imports = [
			inputs.self.modules.homeManager.obsidian
			inputs.self.modules.homeManager.spotify
		];
	};
}
