{
	config,
	lib,
	pkgs,
	...
}: let
	cfg = config.dotfiles.sway;
	fragment = name: {
		"sway/config.d/${name}.config".source = ./. + "/${name}.config";
	};
in {
	imports = [
		../ly
		../noctalia.nix
		../waybar
	];

	options.dotfiles.sway.desktopShell =
		lib.mkOption {
			type = lib.types.enum ["classic" "noctalia"];
			default = "noctalia";
			description = ''
				Desktop shell used by Sway. "noctalia" uses Noctalia's bar,
				notifications, launcher, network UI, volume UI, and lock screen.
				"classic" uses Waybar, Mako, Fuzzel, nm-applet, Pavucontrol,
				and Swaylock.
			'';
		};

	config = {
		programs.noctalia = {
			enable = cfg.desktopShell == "noctalia";
			recommendedServices.enable = cfg.desktopShell == "noctalia";
		};
		programs.waybar.enable = cfg.desktopShell == "classic";
		programs.thunar.enable = true;

		environment.sessionVariables = {
			XCURSOR_THEME = "Adwaita";
			XCURSOR_SIZE = "24";
		};

		programs.sway = {
			enable = true;
			wrapperFeatures.gtk = true;
			extraPackages =
				(with pkgs; [
						adwaita-icon-theme
						libnotify
						brightnessctl
						swayidle
						flameshot
					])
				++ lib.optionals (cfg.desktopShell == "classic") (with pkgs; [
						mako
						fuzzel
						networkmanagerapplet
						pavucontrol
						swaylock
					]);
		};

		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-gtk
				xdg-desktop-portal-wlr
			];
			config.sway = {
				default = ["gtk"];
				"org.freedesktop.impl.portal.Screencast" = ["wlr"];
				"org.freedesktop.impl.portal.Screenshot" = ["wlr"];
			};
		};

		environment.etc =
			lib.mkMerge [
				{
					"sway/config.d/00-system.config".source = ./sway.config;
				}
				(fragment "thunar")
				(fragment "flameshot")
				(lib.mkIf (cfg.desktopShell == "classic") (fragment "classic"))
				(lib.mkIf (cfg.desktopShell == "noctalia") (fragment "noctalia"))
			];

		networking.networkmanager.enable = true;
	};
}
