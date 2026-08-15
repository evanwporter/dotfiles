{
	pkgs,
	config,
	...
}: {
	programs.fish = {
		enable = true;
		shellInit = ''
			source ${config.home.homeDirectory}/dotfiles/fish/config.fish
		'';
		plugins = with pkgs.fishPlugins; [
			{
				name = "bobthefish";
				src = bobthefish.src;
			}
		];
	};

	# Fish creates this file on first launch. Allow Home Manager to take
	# ownership of an existing, unmanaged copy during activation.
	xdg.configFile."fish/config.fish".force = true;
}
