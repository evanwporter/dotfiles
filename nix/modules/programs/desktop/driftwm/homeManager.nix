{
	flake.modules.homeManager.driftwm = {
		xdg.configFile = {
			"driftwm/config.toml".source = ./config.toml;
		};
	};
}
