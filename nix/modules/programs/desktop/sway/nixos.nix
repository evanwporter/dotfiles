{inputs, ...}: {
	flake.modules.nixos.sway = {
		config,
		lib,
		pkgs,
		...
	}: let
		cfg = config.dotfiles.sway;
		launcherCommand =
			{
				bemenu = "j4-dmenu-desktop --dmenu=\"bemenu -i\"";
				rofi = "~/.config/rofi/launchers/type-2/launcher.sh";
			}.${
				cfg.launcher
			};
		fragment = name: {
			"sway/config.d/${name}.config".source = ./. + "/${name}.config";
		};
	in {
		imports = with inputs.self.modules.nixos; [ly waybar];

		options.dotfiles.sway = {
			desktopShell =
				lib.mkOption {
					type = lib.types.enum ["classic" "noctalia"];
					default = "classic";
					description = ''
						Desktop shell used by Sway. "noctalia" uses Noctalia's bar,
						notifications, launcher, network UI, volume UI, and lock screen.
						"classic" uses Waybar, SwayNotificationCenter, a configurable application launcher, NetworkManager's editor, Pavucontrol,
						and Swaylock.
					'';
				};

			fileManager =
				lib.mkOption {
					type = lib.types.enum ["thunar" "dolphin"];
					default = "thunar";
					description = "File manager installed by Sway and opened with Super+E.";
				};

			launcher =
				lib.mkOption {
					type = lib.types.enum ["bemenu" "rofi"];
					default = "bemenu";
					description = "Application launcher bound to Super+Space in the classic Sway shell.";
				};
		};

		config = {
			programs.noctalia = {
				enable = cfg.desktopShell == "noctalia";
				recommendedServices.enable = cfg.desktopShell == "noctalia";
			};
			programs.waybar.enable = cfg.desktopShell == "classic";
			programs.thunar.enable = cfg.fileManager == "thunar";
			home-manager.sharedModules =
				lib.optionals (cfg.launcher == "bemenu") [inputs.self.modules.homeManager.bemenu]
				++ lib.optionals (cfg.launcher == "rofi") [inputs.self.modules.homeManager.rofi];
			environment.systemPackages =
				lib.optionals (cfg.fileManager == "dolphin") [pkgs.kdePackages.dolphin]
				++ lib.optionals (cfg.launcher == "bemenu") [pkgs.j4-dmenu-desktop]
				++ lib.optionals (cfg.launcher == "rofi") [pkgs.rofi];

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
					(lib.mkIf (cfg.desktopShell == "classic") {
							"sway/config.d/30-launcher.config".text = "bindsym $mod+space exec --no-startup-id ${launcherCommand}\n";
						})
				];

			networking.networkmanager.enable = true;
		};
	};
}
