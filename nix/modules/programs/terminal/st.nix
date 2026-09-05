{packagesDir, ...}: {
	flake.modules.nixos.st = {pkgs, ...}: let
		st =
			pkgs.st.overrideAttrs (oldAttrs: {
					src = packagesDir + "/st";
					buildInputs =
						(oldAttrs.buildInputs or [])
						++ [
							pkgs.harfbuzz
							pkgs.libXcursor
						];
				});
	in {
		environment.systemPackages = [
			st
			pkgs.xsel
			pkgs.xclip
		];
	};
}
