{
	inputs,
	packagesDir,
	...
}: {
	flake.modules.nixos.dwl = {pkgs, ...}: let
		dwl =
			pkgs.stdenv.mkDerivation {
				pname = "dwl";
				src = packagesDir + "/dwl";
				nativeBuildInputs = with pkgs; [gnumake pkg-config wayland-scanner];
				buildInputs = with pkgs; [libinput libdrm fcft libxkbcommon wayland wayland-protocols wlroots_0_19 pixman];
				buildPhase = "make";
				installPhase = "make install PREFIX=$out";
			};

		someblocks =
			pkgs.stdenv.mkDerivation {
				pname = "someblocks";
				version = "local";
				src = /home/evanp/someblocks;
				buildPhase = ''
					cp blocks.def.h blocks.h
					# Newer GCC correctly requires signal callbacks to accept the
					# delivered signal number.  Keep the local source unmodified.
					sed -i \
						-e 's/void termhandler()/void termhandler(int signum)/' \
						-e 's/void sigpipehandler()/void sigpipehandler(int signum)/' \
						someblocks.c
					$CC someblocks.c -o someblocks
				'';
				installPhase = "install -Dm755 someblocks $out/bin/someblocks";
			};

		dwlSessionPackage =
			pkgs.writeShellApplication {
				name = "dwl";
				text = ''
					${dwl}/bin/dwl
				'';
				# text = ''
				# 	${someblocks}/bin/someblocks -p | ${dwl}/bin/dwl
				# '';
			};
	in {
		imports = with inputs.self.modules.nixos; [ly polkit];

		# environment.sessionVariables = {
		# 	XCURSOR_THEME = "Adwaita";
		# 	XCURSOR_SIZE = "24";
		# };

		environment.systemPackages = with pkgs;
			[
				bemenu
				brightnessctl
				foot
				fuzzel
				grim
				libnotify
				mako
				pavucontrol
				slurp
				somebar
				swaybg
				swayidle
				swaylock
				wl-clipboard
			]
			++ [dwl someblocks];

		programs.dwl = {
			enable = true;
			package = dwlSessionPackage;

			# extraSessionCommands = ''
			# 	${someblocks}/bin/someblocks &
			# '';
		};

		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-gtk
				xdg-desktop-portal-wlr
			];
			config.common.default = ["gtk"];
			config.dwl = {
				"org.freedesktop.impl.portal.Screencast" = ["wlr"];
				"org.freedesktop.impl.portal.Screenshot" = ["wlr"];
			};
		};
	};
}
