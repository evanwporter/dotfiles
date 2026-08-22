{
	pkgs,
	config,
	lib,
	...
}: {
	programs.fish = {
		enable = true;
		plugins = with pkgs.fishPlugins; [
			{
				name = "bobthefish";
				src = bobthefish.src;
			}
		];
	};

	# Use the repository's config.fish instead of Home Manager's generated one.
	xdg.configFile."fish/config.fish" = {
		force = true;
		source = lib.mkForce "${config.home.homeDirectory}/dotfiles/fish/config.fish";
	};
}
