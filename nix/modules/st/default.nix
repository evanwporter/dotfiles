{
	config,
	lib,
	pkgs,
	...
}: let
	defaultTerminal = config.dotfiles.defaultTerminal;
	st =
		pkgs.st.overrideAttrs (oldAttrs: {
			src = ./st;
			buildInputs = (oldAttrs.buildInputs or []) ++ [pkgs.harfbuzz];
		});
in {
	options.dotfiles.defaultTerminal = lib.mkOption {
		type = lib.types.enum ["kitty" "st"];
		default = "kitty";
		description = "Terminal emulator to install and use by default.";
	};

	config = {
		environment.systemPackages = [
			pkgs.kitty
			st
		];

		environment.variables.TERMINAL = defaultTerminal;

		xdg.terminal-exec = {
			enable = true;
			settings.default = ["${defaultTerminal}.desktop"];
		};
	};
}
