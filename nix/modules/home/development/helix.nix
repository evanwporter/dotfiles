{...}: {
	flake.modules.homeManager.helix = {pkgs, ...}: {
		programs.helix = {
			enable = true;
			package = pkgs.evil-helix;
		};
	};
}
