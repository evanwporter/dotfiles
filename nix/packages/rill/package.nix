{
	stdenv,
	fetchFromGitHub,
	zig_0_17,
	pkg-config,
	wayland,
	wayland-protocols,
	wayland-scanner,
	libxkbcommon,
}: let
	zig = zig_0_17;
in
	stdenv.mkDerivation (finalAttrs: {
			pname = "rill";

			# version = "0.7.0";
			# src =
			# 	fetchFromCodeberg {
			# 		owner = "lzj15";
			# 		repo = "rill";
			# 		rev = "${finalAttrs.version}";
			# 		hash = "sha256-RwHjFImII99ZMNnD0hAK+DmJPnQgZIFcOShhj8wNa+E=";
			# 	};

			version = "0.8.0-dev-6400a3b";
			src =
				fetchFromGitHub {
					owner = "evanwporter";
					repo = "rill";
					rev = "6400a3bd37b07edd450a7ceded249d1238e6bcab";
					hash = "sha256-ND+UN110Gcf6VYUN+jSMGOQ5SGhQZ67hhxY43gXg9hM=";
				};

			zigDeps =
				zig.fetchDeps {
					inherit (finalAttrs) src pname version;
					fetchAll = true;
					hash = "sha256-rOsFulT8MvLIB5UEySl2biLoyMxTUCVbWbIkz4pZ/go=";
				};

			postConfigure = ''
				ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
			'';

			# Embed the config shipped with the pinned source instead of loading ~/.config/rill.
			zigBuildFlags = ["-Dconfig=config.zon"];

			nativeBuildInputs = [
				zig
				pkg-config
				wayland-scanner
			];

			buildInputs = [
				wayland
				wayland-protocols
				libxkbcommon
			];
		})
