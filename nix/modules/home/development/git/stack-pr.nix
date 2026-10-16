{
	flake.modules.homeManager.stack-pr = {
		pkgs,
		packagesDir,
		lib,
		config,
		...
	}: let
		stack-pr = pkgs.callPackage (packagesDir + "/stack-pr/package.nix") {};
	in {
		options.stack-pr.enable =
			lib.mkOption {
				type = lib.types.bool;
				default = false;
				description = "Enable stack-pr";
			};

		config =
			lib.mkIf config.stack-pr.enable {
				home.packages = [
					stack-pr
				];
			};
	};
}
