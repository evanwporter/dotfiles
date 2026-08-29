{inputs, ...}: {
	flake.modules.nixos.terminal = {
		config,
		lib,
		...
	}: {
		imports = with inputs.self.modules.nixos; [kitty st];

		options.terminal.default =
			lib.mkOption {
				type = lib.types.enum ["kitty" "st"];
				default = "kitty";
				description = "Terminal emulator installed and used by default.";
			};

		config = {
			environment.variables.TERMINAL = config.terminal.default;
			xdg.terminal-exec = {
				enable = true;
				settings.default = ["${config.terminal.default}.desktop"];
			};
		};
	};
}
