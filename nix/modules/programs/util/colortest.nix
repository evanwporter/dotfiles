{packagesDir, ...}: {
	flake.modules.homeManager.colortest = {pkgs, ...}: let
		colortest = pkgs.callPackage (packagesDir + "/colortest/package.nix") {};
	in {
		home.packages = [
			colortest
		];
	};
}
