{
	inputs,
	packagesDir,
	...
}: {
	flake.modules.nixos.dwm = {
		lib,
		pkgs,
		...
	}: let
		wallpaper = ../resources/wallpaper/wp.png;
		kittyDwm =
			pkgs.writeShellScriptBin "kitty-dwm" ''
				exec ${pkgs.kitty}/bin/kitty --override font_size=26.0 "$@"
			'';

		dwm =
			pkgs.dwm.overrideAttrs (old: {
					src = packagesDir + "/dwm";
					buildInputs =
						(old.buildInputs or [])
						++ [
							pkgs.libxcb
							pkgs.libXcursor
						];
				});
		dwmblocks =
			pkgs.dwmblocks.overrideAttrs (_: {
					src = packagesDir + "/dwmblocks";
				});
	in {
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
					${pkgs.dunst}/bin/dunst &
					${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio \
						--timer 1800 '${pkgs.systemd}/bin/systemctl suspend' "" &
				'';
			};
		};

		services.libinput = {
			enable = true;
			touchpad.naturalScrolling = true;
		};

		environment.sessionVariables = {
			# GTK 3/4: 2× UI, while avoiding 4× text with the 192-DPI X server.
			# GDK_SCALE = "2";
			# GDK_DPI_SCALE = "0.5";
			# Qt already derives the appropriate scale from the X server's 192 DPI.
			# An additional forced multiplier makes Qt clients such as Flameshot huge.
			XCURSOR_SIZE = "60";
		};

		environment.systemPackages = with pkgs; [
			brightnessctl
			dmenu
			dunst
			feh
			networkmanagerapplet
			libinput-gestures
			dwmblocks
			flameshot
			font-awesome
			pulseaudio
			xidlehook
			xdotool
			libx11
			libXcursor
			libxcb
			kittyDwm
		];
	};
}
