{pkgs, ...}: {
	imports = [
		../ly
		../polkit.nix
		../waybar
	];

	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;

		extraPackages = with pkgs; [
			bemenu
			libnotify
			mako
			brightnessctl
			pavucontrol
			swayidle
			swaylock
		];
	};

	environment.etc."sway/config.d/system".source = ./sway.config;

	networking.networkmanager.enable = true;
}
