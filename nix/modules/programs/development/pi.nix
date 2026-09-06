{dotfilesRoot, ...}: {
	flake.modules.homeManager.pi = {pkgs, ...}: let
	in {
		programs.pi-coding-agent = {
			enable = true;
			extraPackages = with pkgs; [nodejs bun rtk];
		};

		# home.file.".pi".source = osConfig._module.args.impurity.link piConfig;
	};
}
