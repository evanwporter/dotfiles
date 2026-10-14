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
	}: {
		# Per-system attributes can be defined here. The self' and inputs'
		# module parameters provide easy access to attributes of the same
		# system.

		# Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
		# packages.default = pkgs.hello;

		# _module.args is stuff past directly to each module
		_module.args.pkgs =
			import inputs.nixpkgs {
				inherit system;
				overlays = [inputs.self.overlays.default];
				config = {};
			};
	};

	flake = {
		overlays.default = import packagesDir;
	};
}
