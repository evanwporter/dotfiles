{inputs, ...}: let
	system = "x86_64-linux";
	personality = "x11";
in {
	config = {
		flake.modules.nixos.laptop = {
			home-manager.users.evanp.imports = with inputs.self.modules.homeManager; [
				graphical
				btop
				yazi
				vscode
				helix
				zed
			];

			imports = with inputs.self.modules.nixos; [
				./_hardware.nix
				inputs.self.modules.nixos."personality-${personality}"
				gaming
				evanp
				browser
			];
		};

		flake.nixosConfigurations.laptop =
			inputs.nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					inputs.home-manager.nixosModules.home-manager
					inputs.self.modules.nixos.laptop
				];
			};
	};
}
