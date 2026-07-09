{pkgs, ...}: {
	home.packages = with pkgs; [
		# terminal tools
		ripgrep
		fd
		fzf
		curl
		wget
		unzip
		zip
		tree
		fish
		tmux
		bat
		eza
		dust
		yazi
		zoxide
		file
		glow
		erdtree

		# git tools
		lazygit
		gh
		delta
	];
}
