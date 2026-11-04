{
	lib,
	stdenv,
	fetchFromSourcehut,
	meson,
	ninja,
	pkg-config,
	wayland-scanner,
	wayland,
	pixman,
	fontconfig,
	freetype,
	libdrm,
}:
stdenv.mkDerivation {
	name = "neuwld";

	src =
		fetchFromSourcehut {
			owner = "~shrub900";
			repo = "neuwld";
			rev = "712fa71be579f3796b3cd500de87c736a8617dd7";
			hash = "sha256-f2g7zGd81Ld8zNClNCIt901gvq78hBxpCRvFOJmCRts=";
		};

	strictDeps = true;
	__structuredAttrs = true;

	nativeBuildInputs = [
		meson
		ninja
		pkg-config
		wayland-scanner
	];

	buildInputs = [
		pixman
		wayland
		fontconfig
		freetype
		libdrm
	];

	mesonFlags = [
		(lib.mesonEnable "wayland" true)
		(lib.mesonEnable "drm" true)
		(lib.mesonEnable "doxygen" false)
	];

	meta = {
		description = "Drawing library that targets Wayland";
		platforms = lib.platforms.unix;
		homepage = "https://srcdump.net/shrub/neuwld";
		license = lib.licenses.mit;
	};
}
