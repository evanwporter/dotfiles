{
	flake.modules.homeManager.omp = {pkgs, ...}: let
		language_servers = with pkgs; [
			clang-tools
			pyrefly
			slang-server
		];

		extraPackages = with pkgs;
			[nodejs bun rtk] ++ language_servers;

		wrappedOMP =
			pkgs.writeShellScriptBin "omp" ''
				export PATH="${pkgs.lib.makeBinPath extraPackages}:$PATH"
				exec ${pkgs.omp}/bin/omp "$@"
			'';
	in {
		home.packages = [wrappedOMP];
	};
}
