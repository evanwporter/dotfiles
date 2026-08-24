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
		./modules/dotfiles.nix
		./modules/cli.nix
		./modules/dev.nix
		./modules/direnv.nix
		./modules/neovim.nix
		./modules/git.nix
		./modules/fish
		./modules/i3
		./modules/sway
		./modules/niri
	];
}
