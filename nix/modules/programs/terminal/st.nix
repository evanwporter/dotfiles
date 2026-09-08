{packagesDir, ...}: {
	flake.modules.nixos.st = {pkgs, ...}: let
		st =
			pkgs.st.overrideAttrs (oldAttrs: {
					src = packagesDir + "/st-flexipatch";
					buildInputs =
						(oldAttrs.buildInputs or [])
						++ [
							pkgs.harfbuzz
							pkgs.libXcursor
							pkgs.libnotify
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
