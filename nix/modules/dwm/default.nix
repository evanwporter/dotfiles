{
	lib,
	pkgs,
	...
}: let
	wallpaper = ../resources/wallpaper/wp.png;

	dwm-gruvbox =
		pkgs.dwm.overrideAttrs (old: {
				version = "6.5-gruvbox";
				src =
					pkgs.fetchzip {
						url = "https://dl.suckless.org/dwm/dwm-6.5.tar.gz";
						hash = "sha256-Cc4B8evvuRxOjbeOhg3oAs3Nxi/msxWg950/eiq536w=";
					};
				patches = (old.patches or []) ++ [./patches/dwm.patch];
			});

	dwmblocks-gruvbox =
		(pkgs.dwmblocks.override {
				patches = [./patches/dwmblocks.patch];
			}).overrideAttrs (old: {
				postPatch =
					old.postPatch
					+ ''
						cp ${./blocks.h} blocks.def.h
					'';
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
			package = dwm-gruvbox;
			extraSessionCommands = ''
				${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper} &
				${dwmblocks-gruvbox}/bin/dwmblocks &
				${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio \
					--timer 1800 '${pkgs.systemd}/bin/systemctl suspend' "" &
			'';
		};
	};

	environment.systemPackages = with pkgs; [
		brightnessctl
		dmenu
		dwmblocks-gruvbox
		feh
		flameshot
		font-awesome
		kitty
		pulseaudio
		xidlehook
	];
}
