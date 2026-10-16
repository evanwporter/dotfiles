{
	flake.modules.homeManager.polybar = {pkgs, ...}: let
		polybarDwm =
			pkgs.polybar.overrideAttrs {
				version = "3.7.1+git-09eac08";

				src =
					pkgs.fetchgit {
						url = "https://github.com/pgrondek/polybar-dwm";
						rev = "09eac084494d90310a5a27a01b32dc515f6db352";
						hash = pkgs.lib.fakeHash;
					};
			};
	in {
		services.polybar = {
			enable = true;
			package = polybarDwm;
			config = ./config.ini;
		};
	};
}
