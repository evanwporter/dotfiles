{
	flake.modules.nixos.bspwm = {pkgs, ...}: {
		# imports = [inputs.self.modules.nixos.x11];

		services.xserver = {
			windowManager.bspwm = {
				enable = true;
				configFile = ./bspwmrc;
				sxhkd.configFile = ./sxhkd;
			};
		};
	};
}
