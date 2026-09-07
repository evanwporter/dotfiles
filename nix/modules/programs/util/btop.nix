{...}: {
	flake.modules.homeManager.btop = {pkgs, ...}: {
		programs.btop = {
			enable = true;
			package = pkgs.btop;
		};
	};
}
