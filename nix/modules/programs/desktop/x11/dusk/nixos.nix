{
	inputs,
	packagesDir,
	...
}: {
	flake.modules.nixos.dusk = {pkgs, ...}: let
		wallpaper = ../../resources/wallpaper/wp.png;
		dwmblocks =
			pkgs.dwmblocks.overrideAttrs (_: {
					src = packagesDir + "/dwmblocks";
					# Our dwmblocks fork already uses termhandler(int signum),
					# unlike the upstream source targeted by nixpkgs' postPatch.
					postPatch = "";
				});
		ewpPkgs = inputs.ewppkgs-stable.legacyPackages.${pkgs.system};
	in {
		imports = [
			(inputs.ewppkgs-stable + "/nixos/modules/services/x11/window-managers/dusk.nix")
		];

		services.xserver = {
			displayManager.sessionCommands = ''
				${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper} &
				${dwmblocks}/bin/dwmblocks &
				${pkgs.dunst}/bin/dunst &
				${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio \
					--timer 600 '/run/wrappers/bin/slock' "" \
					--timer 1800 '${pkgs.systemd}/bin/systemctl suspend' "" &
			'';

			windowManager.dusk = {
				enable = true;
				package = ewpPkgs.dusk;
			};
		};

		environment.systemPackages = [
			dwmblocks
		];
	};
}
