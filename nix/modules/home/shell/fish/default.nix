{dotfilesRoot, ...}: {
	flake.modules.homeManager.fish = {
		pkgs,
		lib,
		...
	}: {
		programs.fish = {
			enable = true;
			plugins = with pkgs.fishPlugins; [
				{
					name = "bobthefish";
					src =
						pkgs.applyPatches {
							name = "theme-bobthefish-patched";
							src = bobthefish.src;
							patches = [./bobthefish-large-history.patch];
						};
				}
			];
		};

		# Use the repository's config.fish instead of Home Manager's generated one.
		xdg.configFile."fish/config.fish" = {
			force = true;
			source = lib.mkForce (dotfilesRoot + "/fish/config.fish");
		};
	};
}
