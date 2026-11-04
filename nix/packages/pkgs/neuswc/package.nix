{
	lib,
	stdenv,
	fetchFromSourcehut,
	meson,
	pkg-config,
	wayland-scanner,
	libdrm,
	neuwld,
	wayland,
	xwayland,
	wayland-protocols,
	pixman,
	udev,
	ninja,
	fontconfig,
	libxkbcommon,
	libinput,
	libxcb,
	libxcb-wm,
}:
stdenv.mkDerivation {
	name = "neuswc";

	src =
		fetchFromSourcehut {
			owner = "~shrub900";
			repo = "neuswc";
			rev = "050726e3aa6f084512516e8d563fddbacb8dc2de";
			hash = "sha256-z4FY1vVJ0eEKLRO3TvEp3KVDTFHGi3wE7tVqC8NgS+0=";
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
		neuwld
		wayland
		wayland-protocols
		pixman
		libxkbcommon
		fontconfig
		xwayland
		libxcb
		libxcb-wm
		libinput
		libdrm
		udev
	];

	mesonFlags = [
		(lib.mesonEnable "xwayland" true)
		(lib.mesonOption "video" "drm")
	];

	meta = {
		description = "Fork of swc created by wayland.fyi.";
		homepage = "https://srcdump.net/shrub/neuswc";
		platforms = lib.platforms.unix;
		license = lib.licenses.mit;
		mainProgram = "swc-launch";
	};
}
