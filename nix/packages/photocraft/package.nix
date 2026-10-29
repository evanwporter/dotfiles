{
	lib,
	stdenv,
	fetchurl,
	autoPatchelfHook,
	wayland,
	libxkbcommon,
	libx11,
	libxcursor,
	libxi,
	libxrandr,
	vulkan-loader,
	libGL,
}:
stdenv.mkDerivation {
	pname = "photocraft";
	version = "0.16.0";

	src =
		fetchurl {
			url = "https://github.com/storytold/photocraft/releases/download/v0.16.0/photocraft-0.16.0-linux-x86_64.tar.gz";
			hash = "sha256-fBfzYz6/favydiji0mN9kYx8KlsWO4uQNHp4rN32Ngg=";
		};

	nativeBuildInputs = [autoPatchelfHook];

	buildInputs = [stdenv.cc.cc.lib];

	# https://nixos.org/manual/nixpkgs/stable/#setup-hook-autopatchelfhook
	runtimeDependencies = [
		wayland
		libxkbcommon
		libx11
		libxcursor
		libxi
		libxrandr
		vulkan-loader
		libGL
	];

	installPhase = ''
		runHook preInstall

		mkdir -p $out
		cp -r . $out

		runHook postInstall
	'';

	meta = {
		description = "Native image editor and open-source Photoshop reimplementation";
		homepage = "https://github.com/storytold/photocraft";
		license = with lib.licenses; [mit asl20];
		platforms = ["x86_64-linux"];
		mainProgram = "photocraft";
	};
}
