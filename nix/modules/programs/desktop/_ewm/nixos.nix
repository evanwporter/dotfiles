{...}: {
	flake.modules.nixos.ewm = {pkgs, ...}: let
		anvl =
			pkgs.stdenv.mkDerivation {
				pname = "anvl";
				version = "unstable";
				# Build the local ANVL checkout so River changes take effect on the
				# next NixOS rebuild.
				src = /home/evanp/ewm;
				passthru.providedSessions = ["ewm"];

				# ANVL's Makefile invokes the compiler directly, so its binary does not
				# receive Nix runtime-library paths automatically.  Patch it after the
				# install phase; without this River starts but ANVL exits before it can
				# manage any windows.
				nativeBuildInputs = with pkgs; [autoPatchelfHook fd gnumake pkg-config wayland-scanner];
				buildInputs = with pkgs; [wayland wayland-protocols libxkbcommon pixman fcft];

				# ANVL's Makefile leaves prior outputs in .build; remove them so the
				# Nix build always compiles the current checkout and configuration.
				preBuild = "rm -rf .build";
				buildPhase = "make build";
				installPhase = ''
						install -Dm755 .build/anvl $out/bin/anvl
						mkdir -p $out/share/wayland-sessions
						cat > $out/share/wayland-sessions/ewm.desktop <<-EOF
						[Desktop Entry]
						Name=ewm
						Comment=ANVL on River
						Exec=${pkgs.river}/bin/river -log-level debug -c $out/bin/anvl
						Type=Application
						DesktopNames=river
						EOF
				'';
			};
	in {
		services.displayManager.sessionPackages = [anvl];
		environment.systemPackages = with pkgs; [anvl river foot kanshi wl-clipboard];
	};
}
