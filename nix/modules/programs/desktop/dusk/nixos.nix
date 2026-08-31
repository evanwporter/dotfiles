{packagesDir, ...}: {
	flake.modules.nixos.dusk = {
		config,
		lib,
		pkgs,
		...
	}: let
		wallpaper = ../resources/wallpaper/wp.png;
		cfg = config.services.xserver.windowManager.dusk;
		dwmblocks =
			pkgs.dwmblocks.overrideAttrs (_: {
					src = packagesDir + "/dwmblocks";
				});
		dusk =
			pkgs.stdenv.mkDerivation {
				pname = "dusk";
				version = "1.0";
				src = packagesDir + "/dusk";

				nativeBuildInputs = [pkgs.pkg-config];
				buildInputs = with pkgs; [
					libx11
					libXrender
					libxcb
					libxft
					libxinerama
					fontconfig
					dbus
					libconfig
					yajl
				];

				installPhase = ''
					install -Dm755 dusk "$out/bin/dusk"
					install -Dm755 duskc "$out/bin/duskc"
					install -Dm644 dusk.1 "$out/share/man/man1/dusk.1"
					install -Dm644 dusk.desktop "$out/share/xsessions/dusk.desktop"
				'';
			};
	in {
		options.services.xserver.windowManager.dusk = {
			enable = lib.mkEnableOption "dusk";
			extraSessionCommands =
				lib.mkOption {
					default = "";
					type = lib.types.lines;
					description = "Shell commands executed just before Dusk starts.";
				};
			package =
				lib.mkOption {
					type = lib.types.package;
					default = dusk;
					description = "The Dusk package to run.";
				};
		};

		config =
			lib.mkIf cfg.enable {
				services.displayManager.ly.x11Support = lib.mkForce true;
				services.picom = {
					enable = true;
					backend = "glx";
					vSync = true;
				};
				services.xserver = {
					enable = true;
					dpi = 192;
					xkb.layout = "us";
					windowManager.dusk.extraSessionCommands = ''
						${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper} &
						${dwmblocks}/bin/dwmblocks &
						${pkgs.dunst}/bin/dunst &
						${pkgs.xidlehook}/bin/xidlehook --not-when-fullscreen --not-when-audio \\
							--timer 1800 '${pkgs.systemd}/bin/systemctl suspend' "" &
					'';
				};

				environment.sessionVariables.XCURSOR_SIZE = "60";
				services.xserver.windowManager.session =
					lib.singleton {
						name = "dusk";
						start = ''
							${cfg.extraSessionCommands}

							export _JAVA_AWT_WM_NONREPARENTING=1
							exec ${cfg.package}/bin/dusk
						'';
					};

				environment.systemPackages = with pkgs; [
					cfg.package
					brightnessctl
					dmenu
					dunst
					feh
					dwmblocks
					flameshot
					font-awesome
					pulseaudio
					xidlehook
					libx11
					libXcursor
					libxcb
				];
			};
	};
}
