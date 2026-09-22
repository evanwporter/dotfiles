{packagesDir, ...}: {
	flake.modules.nixos.picom = {pkgs, ...}: let
		picom =
			pkgs.picom.overrideAttrs (old: {
					src = packagesDir + "/picom";
				});
	in {
		services.picom = {
			enable = true;
			package = picom;
			backend = "glx";
			vSync = true;
		};
	};

	flake.modules.homeManager.picom = {
		xdg.configFile."picom/picom.conf".source = ./picom.conf;
	};
}
