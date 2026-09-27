{inputs, ...}: {
	flake.modules.nixos.i3 = {pkgs, ...}: {
		imports = with inputs.self.modules.nixos; [ly polkit];

		environment.systemPackages = with pkgs; [
			polybar
			pavucontrol
			libinput-gestures
		];

		environment.etc."i3/config.d/system".source = ./system.config;

		services.xserver = {
			enable = true;
			# Scale the entire X11 desktop to roughly 150% (96 DPI is 100%).
			dpi = 192;

			windowManager.i3.enable = true;
		};

		services.libinput = {
			enable = true;
			touchpad.naturalScrolling = false;
		};

		networking.networkmanager = {
			enable = true;
		};
	};
}
