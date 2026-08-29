{
	lib,
	pkgs,
	...
}: let
	wallpaper = ../resources/wallpaper/wp.png;

	dwm =
		pkgs.dwm.overrideAttrs (_: {
				src = ./dwm;
			});
	dwmblocks =
		pkgs.dwmblocks.overrideAttrs (_: {
				src = ./dwmblocks;
			});
in {
	imports = [../ly];

	services.displayManager.ly.x11Support = lib.mkForce true;
	services.picom = {
		enable = true;
		backend = "glx";
		vSync = true;
	};
	services.xserver = {
		enable = true;
		# Scale X11 applications and dwm's Xft-rendered bar for the laptop's
		# HiDPI display. Firefox and kitty both honor the X server DPI.
		dpi = 192;
		xkb.layout = "us";
		windowManager.dwm = {
			enable = true;
			package = dwm;
			extraSessionCommands = ''
				${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper} &
				${dwmblocks}/bin/dwmblocks &
				${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio \
					--timer 1800 '${pkgs.systemd}/bin/systemctl suspend' "" &
			'';
		};
	};

	environment.systemPackages = with pkgs; [
		brightnessctl
		dmenu
		dwmblocks
		feh
		flameshot
		font-awesome
		kitty
		pulseaudio
		xidlehook
	];
}
