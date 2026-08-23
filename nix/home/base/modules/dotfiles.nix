{
	config,
	lib,
	pkgs,
	dotfilesRoot,
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
		alejandra = linkWhen (hasPackage pkgs.alejandra) "alejandra";
		bat = linkWhen (hasPackage pkgs.bat) "bat";
		delta = linkWhen (config.programs.delta.enable || hasPackage pkgs.delta) "delta";
		erdtree = linkWhen (hasPackage pkgs.erdtree) "erdtree";
		kitty = linkWhen (hasPackage pkgs.kitty) "kitty";
		lazygit = linkWhen (hasPackage pkgs.lazygit) "lazygit";
		polybar = linkWhen (hasPackage pkgs.polybar) "polybar";
		# tmux = linkWhen (hasPackage pkgs.tmux) "tmux";
		yazi = linkWhen (hasPackage pkgs.yazi) "yazi";
	};
}
