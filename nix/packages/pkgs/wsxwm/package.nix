{
	lib,
	stdenv,
	fetchFromGitHub,
	pkg-config,
	pixman,
	wayland,
	neuswc,
	neuwld,
	libxcb,
	libxcb-wm,
	udev,
	libdrm,
	libinput,
	libxkbcommon,
	fontconfig,
}:
stdenv.mkDerivation {
	name = "wsxwm";
	src =
		fetchFromGitHub {
			owner = "uint23";
			repo = "wsxwm";
			rev = "b5d5315d60629d0a9e8b66e9154bd5b5601466c4";
			hash = "sha256-urYUcJLpMWbu6tib1MNC+AxWRtYBXy5kyLuIaApHbRQ=";
		};

	strictDeps = true;
	__structuredAttrs = true;

	nativeBuildInputs = [
		pkg-config
	];

	buildInputs = [
		pixman
		wayland
		neuswc
		neuwld
		libxcb
		libxcb-wm
		udev
		libdrm
		libinput
		libxkbcommon
		fontconfig
	];

	installPhase = ''
		runHook preInstall
		mkdir -p $out/bin
		cp wsxwm $out/bin/wsxwm
		runHook postInstall
	'';

	meta = {
		description = "Way Sexier Window Manager";
		homepage = "https://git.sr.ht/~uint/wsxwm";
		license = lib.licenses.isc;
		mainProgram = "wsxwm";
	};
}
