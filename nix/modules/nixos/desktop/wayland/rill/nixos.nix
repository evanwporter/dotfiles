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
			pkgs.writeShellScript "rill-init" ''
				${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
					WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP
				${pkgs.systemd}/bin/systemctl --user start rill-session.target
				${pkgs.channel}/bin/channel &
				exec /home/evanp/rill/zig-out/bin/rill
			'';

		rillSession =
			pkgs.writeShellScriptBin "rill-session" ''
				trap '${pkgs.systemd}/bin/systemctl --user stop rill-session.target' EXIT
				${pkgs.river}/bin/river -c ${lib.escapeShellArg "${rillInit}"}
			'';

		rillSessionPackage =
			pkgs.runCommand "rill-session" {
				passthru.providedSessions = ["rill"];
			} ''
				mkdir -p $out/share/wayland-sessions
				cat > $out/share/wayland-sessions/rill.desktop <<EOF
				[Desktop Entry]
				Name=Rill
				Comment=River with the Rill scrolling window manager
				Exec=${rillSession}/bin/rill-session
				Type=Application
				DesktopNames=river
				EOF
			'';
	in {
		imports = [
			inputs.self.modules.nixos.polkit
			inputs.self.modules.nixos.noctalia
		];

		# The upstream NixOS River module configures river-classic, not River 0.4.
		services.displayManager.sessionPackages = [rillSessionPackage];
		systemd.user.targets.rill-session = {
			description = "River and Rill graphical session";
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
			swaylock
			wl-clipboard
			swaybg
			wlr-randr
			rill
			rillSession
			channel
		];

		xdg.portal.config.river.default = lib.mkDefault ["wlr" "gtk"];
	};
}
