{
	inputs,
	packagesDir,
	...
}: {
	flake.modules.nixos.dusk = {
		lib,
		pkgs,
		...
	}: let
		wallpaper = ../resources/wallpaper/wp.png;
		dwmblocks =
			pkgs.dwmblocks.overrideAttrs (_: {
					src = packagesDir + "/dwmblocks";
					# Our dwmblocks fork already uses termhandler(int signum),
					# unlike the upstream source targeted by nixpkgs' postPatch.
					postPatch = "";
				});
		dusk = inputs.duskwm.packages.${pkgs.system}.default;
	in {
		config = {
			services.xserver.windowManager.session =
				lib.singleton {
					name = "dusk";
					start = ''
						${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper} &
						${dwmblocks}/bin/dwmblocks &
						${pkgs.dunst}/bin/dunst &
						${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio \\
							--timer 1800 '${pkgs.systemd}/bin/systemctl suspend' "" &

						export _JAVA_AWT_WM_NONREPARENTING=1
						exec ${dusk}/bin/dusk
					'';
				};

			environment.systemPackages = [
				dusk
				dwmblocks
			];
		};
	};
}
