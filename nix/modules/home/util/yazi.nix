{
	flake.modules.homeManager.yazi = {pkgs, ...}: {
		programs.yazi = {
			enable = true;
			package = pkgs.yazi;
			plugins = {
				piper = pkgs.yaziPlugins.piper;
			};
		};

		# Don't show yazi desktop entry
		xdg.desktopEntries.yazi = {
			name = "Yazi";
			noDisplay = true;
		};
	};
}
