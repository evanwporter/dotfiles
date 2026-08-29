{inputs, ...}: {
	flake.modules.homeManager.development = {
		imports = [
			inputs.self.modules.homeManager.cli
			inputs.self.modules.homeManager.direnv
			inputs.self.modules.homeManager.git
			inputs.self.modules.homeManager.neovim
			inputs.self.modules.homeManager.vscode
		];
	};

	perSystem = {pkgs, ...}: let
		neovimDev = inputs.self.homeConfigurations.evanp.config.dotfiles.neovim.finalPackage.devMode;
	in {
		packages.neovim-dev = neovimDev;
		apps.neovim-dev = {
			type = "app";
			program = "${neovimDev}/bin/nvim";
		};
		devShells.default = pkgs.mkShell {packages = [neovimDev];};
	};
}
