{
	inputs,
	config,
	...
}: let
	personality = "x11";
in {
	imports = [../_util];
	flake.modules.nixos.laptop = {
		home-manager.users.${config.primaryUser}.imports = with inputs.self.modules.homeManager; [
			graphical
			yazi
			firefox
			# btop
			# vscode
			# helix
			# zed
			# emacs
			# colortest
		];

		imports = with inputs.self.modules.nixos; [
			./_hardware.nix
			inputs.self.modules.nixos."personality-${personality}"
			gaming
			inputs.self.modules.nixos.${config.primaryUser}
			browser
			nx
			# hydra
		];

		dotfiles.steam.desktopUIScaling = "2";
	};

	flake.nixosConfigurations.laptop =
		inputs.nixpkgs.lib.nixosSystem {
			system = config.system;
			modules = [
				inputs.home-manager.nixosModules.home-manager
				inputs.self.modules.nixos.laptop
			];
		};
}
