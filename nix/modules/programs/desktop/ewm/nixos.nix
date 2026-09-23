{packagesDir, ...}: {
	flake.modules.nixos.ewm = {pkgs, ...}: let
		ewm =
			pkgs.stdenv.mkDerivation {
				pname = "ewm";
				version = "unstable";
				# Build the local ANVL checkout so River changes take effect on the
				# next NixOS rebuild.
				src = packagesDir + "/ewm";
				passthru.providedSessions = ["ewm"];

				# ANVL's Makefile invokes the compiler directly, so its binary does not
				# receive Nix runtime-library paths automatically.  Patch it after the
				# install phase; without this River starts but ANVL exits before it can
				# manage any windows.
				nativeBuildInputs = with pkgs; [
					autoPatchelfHook
					fd
					gnumake
					pkg-config
					wayland-scanner
				];
				buildInputs = with pkgs; [
					wayland
					wayland-protocols
					libxkbcommon
					pixman
					fcft
				];

				# ANVL's Makefile leaves prior outputs in .build; remove them so the
				# Nix build always compiles the current checkout and configuration.
				preBuild = "rm -rf build";
				buildPhase = "make";
				installPhase = ''
					install -Dm755 build/ewm $out/bin/ewm
					mkdir -p $out/share/wayland-sessions
					cat > $out/share/wayland-sessions/ewm.desktop <<-EOF
					[Desktop Entry]
					Name=ewm
					Comment=ewm on river
					Exec=${pkgs.river}/bin/river -log-level debug -c $out/bin/ewm
					Type=Application
					DesktopNames=river
					EOF
				'';
			};
	in {
		services.displayManager.sessionPackages = [ewm];
		environment.systemPackages = with pkgs; [ewm river foot kanshi wl-clipboard];
	};
}
