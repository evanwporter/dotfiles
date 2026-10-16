{
	flake.modules.homeManager.emacs = {pkgs, ...}: let
		# language_servers = with pkgs; [
		# 	clang-tools
		# 	pyrefly
		# 	slang-server
		# ];
		# extraPackages =
		# 	language_servers;
		# wrappedEmacs =
		# 	pkgs.writeShellScriptBin "emacs" ''
		# 		export PATH="${pkgs.lib.makeBinPath extraPackages}:$PATH"
		# 		exec doom ${pkgs.emacs}/bin/emacs "$@"
		# 	'';
	in {
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
