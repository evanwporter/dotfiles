{
	stdenv,
	fetchurl,
	autoPatchelfHook,
	libx11,
	libxcursor,
	libxkbcommon,
	libxrandr,
	libGL,
	libxi,
	vulkan-loader,
}:
stdenv.mkDerivation {
	pname = "gridcraft";
	version = "0.13.0";

	src =
		fetchurl {
			url = "https://github.com/storytold/gridcraft/releases/download/v0.13.0/gridcraft-0.13.0-linux-x86_64.tar.gz";
			hash = "sha256-IMbFbsH/1rvP/ubN7ljPa1yt0vSgSkNg3XzGTVOtl+U=";
		};

	buildInputs = [stdenv.cc.cc.lib];

	nativeBuildInputs = [autoPatchelfHook];

	runtimeDependencies = [
		libx11
		libxcursor
		libxkbcommon
		libxi
		libxrandr
		vulkan-loader
		libGL
	];

	installPhase = ''
		runHook preInstallHook
		mkdir -p $out
		cp -r . $out
		runHook postInstallHook
	'';
}
