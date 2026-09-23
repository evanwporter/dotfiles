{...}: {
	flake.modules.homeManager.yazi = {pkgs, ...}: {
		programs.yazi = {
			enable = true;
			package = pkgs.yazi;
		};

		# Don't show yazi desktop entry
		xdg.desktopEntries.yazi = {
			name = "Yazi";
			noDisplay = true;
		};
	};
}
