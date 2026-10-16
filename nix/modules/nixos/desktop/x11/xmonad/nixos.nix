{resourcesDir, ...}: {
	flake.modules.nixos.xmonad = {pkgs, ...}: let
		wallpaper = resourcesDir + "/wallpaper/wp.png";
	in {
		# imports = [inputs.self.modules.nixos.x11];

		services.xserver = {
			windowManager.xmonad = {
				enable = true;
				enableContribAndExtras = true;
				# Substitute immutable store paths into the standalone Haskell config.
				config =
					pkgs.replaceVars ./config.hs {
						inherit wallpaper;
						feh = pkgs.feh;
						dunst = pkgs.dunst;
					};
			};
		};

		environment.systemPackages = with pkgs; [
			xmobar
		];
	};
}
