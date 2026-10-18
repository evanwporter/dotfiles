{
	lib,
	stdenv,
	fetchFromCodeberg,
	zig_0_16,
	pkg-config,
	wayland,
	wayland-protocols,
	wayland-scanner,
	libxkbcommon,
	river,
}: let
	zig = zig_0_16;
in
	stdenv.mkDerivation (finalAttrs: {
		pname = "channel";
		version = "0.5.1-unstable-2026-10-17";
		src = fetchFromCodeberg {
			owner = "Sivecano";
			repo = "channel";
			rev = "441ca0f411c28b583dcb86e1f51f9ecc6af72c1c";
			hash = "sha256-y7e+lYXN6J9JclDjR5ALo1DLUwfpdbzdQSzTqugU3kM=";
		};
		zigDeps = zig.fetchDeps {
			inherit (finalAttrs) src pname version;
			fetchAll = true;
			hash = "sha256-fI1oPZrNWivFSGCs4eLnOx1dbkMDOaiTjboR79RlTDU=";
		};
		postConfigure = ''
			ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
		'';
		nativeBuildInputs = [zig pkg-config wayland-scanner];
		buildInputs = [wayland wayland-protocols libxkbcommon river];
		meta = {
			description = "Input configuration client for River";
			homepage = "https://codeberg.org/Sivecano/channel";
			license = lib.licenses.agpl3Only;
			platforms = lib.platforms.linux;
			mainProgram = "channel";
		};
	})
