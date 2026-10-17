{
	flake.modules.homeManager.noctalia = {pkgs, ...}: {
		home.packages = [pkgs.noctalia];

		xdg.configFile = {
			"noctalia/config.toml".source = ./config.toml;
		};
	};
}
