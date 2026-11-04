{...}: {
	flake.modules.homeManager.feh = {...}: let
		imageMimeTypes = [
			"image/avif"
			"image/bmp"
			"image/gif"
			"image/heic"
			"image/heif"
			"image/jpeg"
			"image/jxl"
			"image/png"
			"image/svg+xml"
			"image/tiff"
			"image/webp"
		];
	in {
		xdg.mimeApps.defaultApplications =
			builtins.listToAttrs (map (mimeType: {
						name = mimeType;
						value = "feh.desktop";
					})
				imageMimeTypes);
	};
}
