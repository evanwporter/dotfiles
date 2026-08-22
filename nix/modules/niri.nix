{pkgs, ...}: {
	imports = [
		./ly
		./polkit.nix
	];

	programs.niri.enable = true;

	environment.systemPackages = with pkgs; [
		brightnessctl
		fuzzel
		libnotify
		mako
		pavucontrol
		swayidle
		swaybg
		swaylock
		waybar
		xwayland-satellite
	];
}
