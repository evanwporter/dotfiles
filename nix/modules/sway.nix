{pkgs, ...}: {
	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
	};

	environment.systemPackages = with pkgs; [
		brightnessctl
		fuzzel
		pavucontrol
		swayidle
		swaylock
		waybar
	];

	services.displayManager.sddm = {
		enable = true;
		wayland.enable = true;
	};

	networking.networkmanager.enable = true;
}
