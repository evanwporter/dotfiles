{
	config,
	lib,
	pkgs,
	osConfig ? null,
	...
}: let
	systemPackages =
		if osConfig == null
		then []
		else osConfig.environment.systemPackages;

	availablePackages = config.home.packages ++ systemPackages;
	hasRofi = lib.any (package: lib.getName package == lib.getName pkgs.rofi) availablePackages;
in {
	xdg.configFile.rofi =
		lib.mkIf hasRofi {
			source = ./config;
		};

	home.packages = with pkgs; [
		icomoon-feather
		nerd-fonts.iosevka
	];
}
