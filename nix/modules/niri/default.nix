{pkgs, ...}: {
	imports = [
		../ly
		../polkit.nix
		../waybar
	];

	programs.niri.enable = true;

	environment.etc."niri/config.kdl".source = ./system.kdl;

	environment.systemPackages = with pkgs; [
		brightnessctl
		fuzzel
		libnotify
		mako
		pavucontrol
		swayidle
		swaybg
		swaylock
		xwayland-satellite
	];
}
