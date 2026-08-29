{inputs, ...}: {
	flake.modules.homeManager.home-default = {
		imports = [
			inputs.self.modules.homeManager.dotfiles
			# inputs.self.modules.homeManager.cursor
		];
		home.stateVersion = "26.05";
	};
}
