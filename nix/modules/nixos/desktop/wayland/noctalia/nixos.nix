{inputs, ...}: {
	flake.modules.nixos.noctalia = {
		programs.noctalia = {
			enable = true;
			recommendedServices.enable = true;
		};

		home-manager.sharedModules = [inputs.self.modules.homeManager.noctalia];
	};
}
