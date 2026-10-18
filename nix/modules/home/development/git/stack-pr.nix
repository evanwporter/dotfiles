{
	flake.modules.homeManager.stack-pr = {
		pkgs,
		lib,
		config,
		...
	}: {
		options.programs.stack-pr.enable =
			lib.mkOption {
				type = lib.types.bool;
				default = false;
				description = "Enable stack-pr";
			};

		config =
			lib.mkIf config.programs.stack-pr.enable {
				home.packages = [
					pkgs.stack-pr
				];
			};
	};
}
