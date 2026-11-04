{
	packagesDir,
	resourcesDir,
	...
}: {
	flake.modules.nixos.dwm = {
		config,
		pkgs,
		...
	}: let
		wallpaper = resourcesDir + "/wallpaper/wp.png";

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

		# dwm =
		# 	pkgs.writeShellScriptBin "dwm" ''
		# 		exec /home/evanp/dwm/dwm "$@"
		# 	'';

		dwmblocks =
			pkgs.dwmblocks.overrideAttrs (_: {
					src = packagesDir + "/dwmblocks";
					postPatch = "";
				});

		xhidecursor = pkgs.callPackage (packagesDir + "/xhidecursor/package.nix") {};
	in {
		services.xserver = {
			windowManager.dwm = {
				enable = true;
				package = dwm;
				extraSessionCommands = ''
					${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper} &
					${dwmblocks}/bin/dwmblocks &
					${pkgs.dunst}/bin/dunst &
					${xhidecursor}/bin/xhidecursor &
				'';
			};
		};
	};
}
