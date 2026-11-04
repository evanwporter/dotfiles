{
	lib,
	stdenv,
	fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
		pname = "nob";
		version = "3.10.0";

		src =
			fetchFromGitHub {
				owner = "tsoding";
				repo = "nob.h";
				tag = "v${finalAttrs.version}";
				hash = "sha256-zWSlvnB/Iavkmd+JJHTmcFGNJkeFesNLb1T7OCW2IbU=";
			};

		setupHook = ./setup-hook.sh;

		installPhase = ''
			install -Dm644 nob.h $out/include/nob.h
		'';

		meta = {
			description = "Header-only C library for writing build systems in C";
			homepage = "https://github.com/tsoding/nob.h";
			changelog = "https://github.com/tsoding/nob.h/releases/tag/v${finalAttrs.version}";
			license = lib.licenses.mit;
			maintainers = with lib.maintainers; [evanwporter];
			platforms = lib.platforms.all;
		};
	})
