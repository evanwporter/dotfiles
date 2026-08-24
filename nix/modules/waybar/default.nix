{
	config,
	lib,
	pkgs,
	...
}: {
	environment.etc = lib.mkIf config.programs.waybar.enable (
		lib.mkMerge [
			(lib.mkIf config.programs.niri.enable {
					"xdg/waybar/config".source = ./niri.jsonc;
				})
			(lib.mkIf config.programs.sway.enable {
					"xdg/waybar/config".source = ./sway.jsonc;
				})
			{
				"xdg/waybar/style.css".source = ./style.css;
			}
		]
	);
}
