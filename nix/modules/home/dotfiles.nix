{dotfilesRoot, ...}: {
	flake.modules.homeManager.dotfiles = {
		config,
		lib,
		pkgs,
		osConfig ? null,
		...
	}: let
		systemPackages =
			if osConfig == null
			then []
			else osConfig.environment.systemPackages;

		availablePackages = config.home.packages ++ systemPackages;

		hasPackage = package:
			lib.any (candidate: lib.getName candidate == lib.getName package) availablePackages;

		linkWhen = condition: directory:
			lib.mkIf condition {
				source = dotfilesRoot + "/${directory}";
			};
	in {
		xdg.configFile = {
			alejandra = linkWhen true "alejandra";
			bat = linkWhen (hasPackage pkgs.bat) "bat";
			delta = linkWhen (config.programs.delta.enable || hasPackage pkgs.delta) "delta";
			erdtree = linkWhen (hasPackage pkgs.erdtree) "erdtree";
			kitty = linkWhen (hasPackage pkgs.kitty) "kitty";
			lazygit = linkWhen (hasPackage pkgs.lazygit) "lazygit";
			# polybar = linkWhen (hasPackage pkgs.polybar) "polybar";
			# tmux = linkWhen (hasPackage pkgs.tmux) "tmux";
			"yazi/keymap.toml" = linkWhen (hasPackage pkgs.yazi) "yazi/keymap.toml";
			"yazi/theme.toml" = linkWhen (hasPackage pkgs.yazi) "yazi/theme.toml";
			"yazi/yazi.toml" = linkWhen (hasPackage pkgs.yazi) "yazi/yazi.toml";
		};
	};
}
