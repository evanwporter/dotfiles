{inputs, ...}: let
	system = "x86_64-linux";
	personality = "x11";
in {
	flake.modules.nixos.laptop = {
		home-manager.users.evanp.imports = with inputs.self.modules.homeManager; [
			graphical
			btop
			yazi
			vscode
			helix
			zed
			emacs
			colortest
			firefox
		];

		imports = with inputs.self.modules.nixos; [
			./_hardware.nix
			inputs.self.modules.nixos."personality-${personality}"
			gaming
			evanp
			browser
			nx
			# hydra
		];

		dotfiles.steam.desktopUIScaling = "2";
	};

	flake.nixosConfigurations.laptop =
		inputs.nixpkgs.lib.nixosSystem {
			inherit system;
			modules = [
				inputs.home-manager.nixosModules.home-manager
				inputs.self.modules.nixos.laptop
			];
		};
}
