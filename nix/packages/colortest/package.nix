{
	lib,
	stdenv,
	fetchFromGitHub,
	bash,
}:
stdenv.mkDerivation rec {
	pname = "colortest";
	version = "3.0.7";

	src =
		fetchFromGitHub {
			owner = "pablopunk";
			repo = "colortest";
			tag = "v${version}";
			hash = "sha256-Jmq+71vol5PTkFDKgHOHMu3XrTUJ73zQACtl5BVJ+sk=";
		};

	dontBuild = true;

	installPhase = ''
		runHook preInstall

		mkdir -p $out/bin
		install -Dm755 colortest $out/bin/colortest

		substituteInPlace $out/bin/colortest \
			--replace-fail '#!/bin/bash' '#!${bash}/bin/bash'

		runHook postInstall
	'';

	meta = {
		description = "Quickly show all your terminal colors";
		homepage = "https://github.com/pablopunk/colortest";
		license = lib.licenses.mit;
		platforms = lib.platforms.unix;
		mainProgram = "colortest";
	};
}
