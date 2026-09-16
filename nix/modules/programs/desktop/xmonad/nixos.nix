{inputs, ...}: {
	flake.modules.nixos.xmonad = {pkgs, ...}: let
		wallpaper = ../resources/wallpaper/wp.png;
	in {
		# imports = [inputs.self.modules.nixos.x11];

		services.xserver = {
			windowManager.xmonad = {
				enable = true;
				enableContribAndExtras = true;
			};
		};
	};
}
