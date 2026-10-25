{
	inputs,
	packagesDir,
	...
}: {
	systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
	perSystem = {
		config,
		self', # per system equivalent of self
		inputs',
		pkgs,
		system,
		...
	}: let
		epkgs =
			import inputs.nixpkgs {
				inherit system;
				overlays = [inputs.self.overlays.default];
				config = {};
			};
	in {
		# Per-system attributes can be defined here. The self' and inputs'
		# module parameters provide easy access to attributes of the same
		# system.

		# Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
		# packages.default = epkgs.muuk;
		# packages.default = epkgs.stack-pr;
		packages = {
			stack-pr = pkgs.stack-pr;
			sxwm = pkgs.sxwm;
			rill = pkgs.rill;
			kwm = pkgs.kwm;
			channel = pkgs.channel;
		};
		# packages.default = pkgs.reflect-cpp;

		# _module.args is stuff past directly to each module
		_module.args.pkgs = epkgs;
	};

	flake = {
		overlays.default = import packagesDir;
	};
}
