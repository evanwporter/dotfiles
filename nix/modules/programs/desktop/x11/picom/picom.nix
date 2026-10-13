{
	inputs,
	packagesDir,
	...
}: {
	flake.modules.nixos.picom = {
		lib,
		pkgs,
		...
	}: {
		services.picom = {
			enable = true;
			package = pkgs.picom;
			backend = "glx";
			vSync = true;
		};

		# Do not pass NixOS's generated config. Picom discovers the Home
		# Manager-linked config at $XDG_CONFIG_HOME/picom/picom.conf instead.
		systemd.user.services.picom.serviceConfig.ExecStart =
			lib.mkForce
			"${lib.getExe pkgs.picom} --backend glx";

		home-manager.sharedModules = [inputs.self.modules.homeManager.picom];
	};

	flake.modules.homeManager.picom = {
		xdg.configFile."picom/picom.conf".source = ./picom.conf;
	};
}
