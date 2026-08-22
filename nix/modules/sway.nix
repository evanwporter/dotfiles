{pkgs, ...}: {
	imports = [
		./ly
		./polkit.nix
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
			waybar
		];
	};

	# services.displayManager.sddm = {
	# 	enable = true;
	# 	wayland.enable = true;
	# };

	networking.networkmanager.enable = true;
}
