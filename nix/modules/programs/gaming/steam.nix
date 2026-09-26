{...}: {
	flake.modules.nixos.steam = {
		config,
		lib,
		...
	}: let
		cfg = config.dotfiles.steam;
	in {
		options.dotfiles.steam.desktopUIScaling =
			lib.mkOption {
				type = lib.types.nullOr lib.types.str;
				default = 1.0;
				example = "2";
				description = "Steam desktop UI scaling factor.";
			};

		config = {
			# Config options from https://nixos.wiki/wiki/Steam
			programs.steam = {
				enable = true;
				remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
				dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
				localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
			};

			environment.sessionVariables = {
				STEAM_FORCE_DESKTOPUI_SCALING = cfg.desktopUIScaling;
			};
		};
	};
}
