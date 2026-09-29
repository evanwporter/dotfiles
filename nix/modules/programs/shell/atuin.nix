{
	flake.modules.homeManager.atuin = {
		programs.atuin = {
			enable = true;
			enableFishIntegration = true;
		};
	};
}
