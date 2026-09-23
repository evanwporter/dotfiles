{
	inputs,
	packagesDir,
	...
}: {
	flake.modules.nixos.x11 = {
		lib,
		pkgs,
		...
	}: let
		lockscreenBackground = ../resources/wallpaper/quentinmarsollier-unexplored.png;

		slock =
			pkgs.slock.overrideAttrs (old: {
					src = packagesDir + "/slock";
					buildInputs = (old.buildInputs or []) ++ [pkgs.imlib2];
				});

		dmenu =
			pkgs.dmenu.overrideAttrs (_: {
					src = packagesDir + "/dmenu";
				});

		xhidecursor = pkgs.callPackage (packagesDir + "/xhidecursor/package.nix") {};
	in {
		imports = with inputs.self.modules.nixos; [powermenu picom];

		services.displayManager.ly.x11Support = lib.mkForce true;

		programs.slock = {
			enable = true;
			package = slock;
		};

		services.xserver = {
			enable = true;
			# Scale X11 applications and Xft-rendered bars for the laptop's HiDPI
			# display. Firefox and kitty both honor the X server DPI.
			# TODO: Put this in the laptop config file
			dpi = 192;
			xkb.layout = "us";
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

		environment.etc."slock/bg.png".source = lockscreenBackground;

		environment.systemPackages = with pkgs; [
			brightnessctl
			dmenu
			dunst
			feh
			networkmanagerapplet
			libinput-gestures
			flameshot
			font-awesome
			pulseaudio
			xidlehook
			xdotool
			libx11
			libXcursor
			libxcb
			nautilus
			pavucontrol
			j4-dmenu-desktop
			xhidecursor
		];
	};
}
