{inputs, ...}: {
	flake.modules.nixos.sway = {
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
		imports = with inputs.self.modules.nixos; [ly waybar];

		options.dotfiles.sway = {
			desktopShell =
				lib.mkOption {
					type = lib.types.enum ["classic" "noctalia"];
					default = "noctalia";
					description = ''
						Desktop shell used by Sway. "noctalia" uses Noctalia's bar,
						notifications, launcher, network UI, volume UI, and lock screen.
						"classic" uses Waybar, SwayNotificationCenter, Rofi, NetworkManager's editor, Pavucontrol,
						and Swaylock.
					'';
				};

			fileManager =
				lib.mkOption {
					type = lib.types.enum ["thunar" "dolphin"];
					default = "thunar";
					description = "File manager installed by Sway and opened with Super+E.";
				};
		};

		config = {
			programs.noctalia = {
				enable = cfg.desktopShell == "noctalia";
				recommendedServices.enable = cfg.desktopShell == "noctalia";
			};
			programs.waybar.enable = cfg.desktopShell == "classic";
			programs.thunar.enable = cfg.fileManager == "thunar";
			environment.systemPackages =
				lib.optionals (cfg.fileManager == "dolphin") [
					pkgs.kdePackages.dolphin
				];

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
							acpi
							rofi
							networkmanagerapplet
							pavucontrol
							swaylock
							swaynotificationcenter
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
						"sway/config.d/00-system.config".source = ./system.config;
					}
					(fragment cfg.fileManager)
					(fragment "flameshot")
					(fragment cfg.desktopShell)
				];

			networking.networkmanager.enable = true;
		};
	};
}
