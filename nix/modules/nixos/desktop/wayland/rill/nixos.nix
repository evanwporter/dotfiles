{inputs, ...}: {
	flake.modules.nixos.rill = {
		lib,
		pkgs,
		...
	}: let
		rill =
			pkgs.rill.overrideAttrs (_: {
					version = "0.8.0-dev-6400a3b";
					src =
						pkgs.fetchFromGitHub {
							owner = "evanwporter";
							repo = "rill";
							rev = "6400a3bd37b07edd450a7ceded249d1238e6bcab";
							hash = "sha256-ND+UN110Gcf6VYUN+jSMGOQ5SGhQZ67hhxY43gXg9hM=";
						};
				});

		rillInit =
			pkgs.writeShellScriptBin "rill-init" ''
				# Inside this script we have already setup our wayland environment
				# ie: WAYLAND_DISPLAY = 1

				# Updates the activation environment with the system variables that
				# were presumably set by river
				# https://dbus.freedesktop.org/doc/dbus-update-activation-environment.1.html?utm_source=chatgpt.com
				${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
				    WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP
				${pkgs.systemd}/bin/systemctl --user start rill-session.target
				${pkgs.channel}/bin/channel & exec /home/evanp/rill/zig-out/bin/rill
			'';

		rillSession =
			pkgs.writeShellScriptBin "rill-session" ''
				# Runs the systemctl command when the rill-session script has EXITed
				trap '${pkgs.systemd}/bin/systemctl --user stop rill-session.target' EXIT
				${pkgs.river}/bin/river -c ${"${rillInit}/bin/rill-init"}
			'';

		rillSessionPackage =
			pkgs.writeTextFile {
				name = "rill.desktop";
				destination = "/share/wayland-sessions/rill.desktop";
				text = ''
					[Desktop Entry]
					Name=rill
					Comment=River with the Rill scrolling window manager
					Exec=${lib.getExe rillSession}
					Type=Application
					DesktopNames=river
				'';
			}
			// {
				providedSessions = ["rill"];
			};
	in {
		imports = [
			inputs.self.modules.nixos.polkit
			inputs.self.modules.nixos.noctalia
		];

		services.displayManager.sessionPackages = [rillSessionPackage];
		systemd.user.targets.rill-session = {
			description = "rill graphical session";
			bindsTo = ["graphical-session.target"];
			wants = ["graphical-session-pre.target"];
			after = ["graphical-session-pre.target"];
			before = ["graphical-session.target"];
		};

		home-manager.sharedModules = [
			inputs.self.modules.homeManager.kanshi
			{
				services.kanshi.systemdTarget = "rill-session.target";
				xdg.configFile."river/config.rh".source = ./config.rh;
				xdg.configFile."rill/config.zon".source = ./config.zon;
			}
		];

		environment.etc."rill/config.zon".source = ./config.zon;

		environment.systemPackages = with pkgs; [
			river
			xwayland
			swaylock
			wl-clipboard
			swaybg
			wlr-randr
			rill
			rillSession
			channel
		];

		xdg.portal = {
			enable = true;
			wlr.enable = true;
			extraPortals = [pkgs.xdg-desktop-portal-gtk];
			config.river = {
				default = lib.mkDefault ["gtk"];
				"org.freedesktop.impl.portal.Screenshot" = ["wlr"];
				"org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
			};
		};
	};
}
