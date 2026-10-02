{packagesDir, ...}: {
	flake.modules.nixos.dwm = {pkgs, ...}: let
		wallpaper = ../../resources/wallpaper/wp.png;

		dwm =
			pkgs.dwm.overrideAttrs (old: {
					src = packagesDir + "/dwm";
					buildInputs =
						(old.buildInputs or [])
						++ [
							pkgs.libxcb
							pkgs.libXcursor
							pkgs.imlib2
						];
				});

		dwmblocks =
			pkgs.dwmblocks.overrideAttrs (_: {
					src = packagesDir + "/dwmblocks";
					postPatch = "";
				});

		xhidecursor = pkgs.callPackage (packagesDir + "/xhidecursor/package.nix") {};
	in {
		# imports = [inputs.self.modules.nixos.x11];

		services.xserver = {
			windowManager.dwm = {
				enable = true;
				package = dwm;
				extraSessionCommands = ''
					${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper} &
					${dwmblocks}/bin/dwmblocks &
					${pkgs.dunst}/bin/dunst &
					${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio \
						--timer 600 '/run/wrappers/bin/slock' "" \
						--timer 1800 '${pkgs.systemd}/bin/systemctl suspend' "" &
					${xhidecursor}/bin/xhidecursor &
				'';
			};
		};
	};
}
