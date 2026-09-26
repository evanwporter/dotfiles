{inputs, ...}: {
	flake.modules.homeManager.home-default = {
		imports = [
			inputs.self.modules.homeManager.dotfiles
		];
		home.stateVersion = "26.05";
	};
}
