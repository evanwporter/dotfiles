{
	flake.modules.homeManager.emacs = {pkgs, ...}: {
		programs.emacs = {
			enable = true;
			package = pkgs.emacs;
			extraPackages = epkgs: [epkgs.vterm];
			extraConfig = ''
				(setq standard-indent 2)
			'';
		};
	};
}
