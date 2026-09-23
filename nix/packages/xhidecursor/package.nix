{
	lib,
	stdenv,
	fetchFromGitHub,
	libX11,
	libXfixes,
	libXi,
	pkg-config,
}:
stdenv.mkDerivation {
	pname = "xhidecursor";
	version = "unstable-2025-12-16";

	src =
		fetchFromGitHub {
			owner = "astier";
			repo = "xhidecursor";
			rev = "master";
			hash = "sha256-RYabrv/PLN66HL10j0TjUue+rcH5dP7OgTHdsmSQpyc=";
	};

	nativeBuildInputs = [
		pkg-config
	];

	buildInputs = [
		libX11
		libXfixes
		libXi
	];

	installFlags = [
		"PREFIX=$(out)"
	];

	meta = {
		description = "Minimal X11 utility to hide the cursor on keypress";
		homepage = "https://github.com/astier/xhidecursor";
		license = lib.licenses.mit;
		platforms = lib.platforms.unix;
		mainProgram = "xhidecursor";
	};
}
