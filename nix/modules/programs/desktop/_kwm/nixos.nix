{
	flake.modules.nixos.kwm = {pkgs, ...}: let
		kwmDeps = pkgs.callPackage ./_deps.nix {};

		kwm =
			pkgs.stdenv.mkDerivation {
				pname = "kwm";
				version = "0.3.0";

				# src =
				# 	pkgs.fetchFromGitHub {
				# 		owner = "kewuaa";
				# 		repo = "kwm";
				# 		rev = "v${version}";
				# 		hash = "sha256-hX76wTHPTgg5RAHILfd3CjRKPlgAwGSK3lG82IFoUUs=";
				# 	};

				src = /home/evanp/kwm;

				passthru.providedSessions = ["kwm"];

				nativeBuildInputs = with pkgs; [
					zig_0_16
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

				preBuild = ''
					rm -rf zig-pkg
					mkdir -p zig-pkg
					cp -r ${kwmDeps}/* zig-pkg
				'';

				buildPhase = ''
					runHook preBuild

					zig build --release=fast

					runHook postBuild
				'';

				installPhase = ''
					runHook preInstall

					install -Dm755 zig-out/bin/kwm $out/bin/kwm

					mkdir -p $out/share/kwm
					cp config.zon $out/share/kwm/config.zon

					mkdir -p $out/share/wayland-sessions
					cat > $out/share/wayland-sessions/kwm.desktop <<EOF
					[Desktop Entry]
					Name=kwm
					Comment=kwm on River
					Exec=${pkgs.river}/bin/river -c $out/bin/kwm
					Type=Application
					DesktopNames=river
					EOF

					runHook postInstall
				'';
			};
	in {
		services.displayManager.sessionPackages = [
			kwm
		];

		environment.systemPackages = [
			kwm
			pkgs.river
			pkgs.foot
			pkgs.wl-clipboard-rs
			pkgs.wmenu
		];
	};
}
