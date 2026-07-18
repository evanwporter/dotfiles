{
	username,
	homeDirectory,
	...
}: {
	home = {
		inherit username homeDirectory;
		stateVersion = "26.05";
	};

	imports = [
		./modules/cli.nix
		./modules/dev.nix
		./modules/neovim.nix
		./modules/git.nix
	];
}
