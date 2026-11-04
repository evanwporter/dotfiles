{...}: {
	flake.modules.nixos.xidlehook = {
		config,
		pkgs,
		...
	}: {
		services.xserver.xidlehook = {
			enable = true;
			notWhenFullscreen = true;
			notWhenAudio = true;
			timers = [
				{
					duration = 600;
					command = "${config.security.wrapperDir}/slock";
				}
				{
					duration = 1800;
					command = "${pkgs.systemd}/bin/systemctl suspend";
				}
			];
		};
	};
}
