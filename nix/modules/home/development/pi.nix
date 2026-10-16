{...}: {
	flake.modules.homeManager.pi = {pkgs, ...}: let
		language_servers = with pkgs; [
			clang-tools
			pyrefly
			slang-server
		];
	in {
		programs.pi-coding-agent = {
			enable = true;
			extraPackages = with pkgs; [nodejs bun rtk] ++ language_servers;
		};

		# home.file.".pi".source = osConfig._module.args.impurity.link piConfig;
	};
}
