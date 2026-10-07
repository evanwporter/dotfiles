{inputs, ...}: {
	flake.modules.nixos.noctalia = {
		networking.networkmanager.enable = true;
		hardware.bluetooth.enable = true;
		services.power-profiles-daemon.enable = true;
		services.upower.enable = true;

		programs.noctalia = {
			enable = true;
			recommendedServices.enable = true;
		};

		home-manager.sharedModules = [inputs.self.modules.homeManager.noctalia];
	};
}
