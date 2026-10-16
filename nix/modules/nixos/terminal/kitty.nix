{...}: {
	flake.modules.nixos.kitty = {pkgs, ...}: {
		environment.systemPackages = [pkgs.kitty];
	};

	flake.modules.homeManager.kitty = {
		programs.kitty.enable = true;
	};
}
