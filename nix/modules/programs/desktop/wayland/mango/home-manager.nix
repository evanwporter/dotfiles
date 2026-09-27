{inputs, ...}: {
	flake.modules.homeManager.mango = {
		imports = with inputs.self.modules.homeManager; [noctalia];
		xdg.configFile = {
			"mango/config.conf".source = ./config.conf;
		};
	};
}
