{inputs, ...}: {
	flake.modules.homeManager.eww = {pkgs, ...}: {
		imports = with inputs.self.modules.homeManager; [mediacontrol];
		programs.eww = {
			enable = true;
			package = pkgs.eww;
		};

		xdg.configFile = {
			"eww/".source = ./eww;
		};
	};
}
