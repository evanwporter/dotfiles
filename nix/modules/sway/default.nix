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
			fuzzel
			libnotify
			mako
			brightnessctl
			pavucontrol
			swayidle
			swaylock
			flameshot
		];
	};

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			xdg-desktop-portal-wlr
		];
		config.sway = {
			default = ["gtk"];
			"org.freedesktop.impl.portal.Screencast" = ["wlr"];
			"org.freedesktop.impl.portal.Screenshot" = ["wlr"];
		};
	};

	environment.etc."sway/config.d/system".source = ./sway.config;

	networking.networkmanager.enable = true;
}
