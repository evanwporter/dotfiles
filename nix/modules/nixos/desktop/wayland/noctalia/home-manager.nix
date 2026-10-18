{
	flake.modules.homeManager.noctalia = {pkgs, ...}: {
		home.packages = [pkgs.noctalia];

		xdg.dataFile."noctalia/plugins/rill-workspaces" = {
			source = ./plugins/rill-workspaces;
			recursive = true;
			force = true;
		};

		xdg.configFile = {
			"noctalia/config.toml".source = ./config.toml;
		};
	};
}
