{
	inputs,
	packagesDir,
	...
}: {
	flake.modules.nixos.picom = {
		lib,
		pkgs,
		...
	}: let
		picom =
			pkgs.picom.overrideAttrs (_: {
					src = packagesDir + "/picom";
				});
	in {
		services.picom = {
			enable = true;
			package = picom;
			backend = "glx";
			vSync = true;
		};

		# Do not pass NixOS's generated config. Picom discovers the Home
		# Manager-linked config at $XDG_CONFIG_HOME/picom/picom.conf instead.
		systemd.user.services.picom.serviceConfig.ExecStart =
			lib.mkForce
			"${lib.getExe picom} --backend glx";

		home-manager.sharedModules = [inputs.self.modules.homeManager.picom];
	};

	flake.modules.homeManager.picom = {
		xdg.configFile."picom/picom.conf".source = ./picom.conf;
	};
}
