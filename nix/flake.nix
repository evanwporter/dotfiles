{
	description = "Evan's Nix config";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixos-wsl.url = "github:nix-community/NixOS-WSL";
		spotify-nixpkgs.url = "github:NixOS/nixpkgs/9ae611a455b90cf061d8f332b977e387bda8e1ca";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		mnw.url = "github:Gerg-L/mnw";
	};

	outputs = inputs @ {
		nixpkgs,
		nixos-wsl,
		home-manager,
		...
	}: let
		system = "x86_64-linux";

		mkHome = {
			username,
			homeDirectory ? "/home/${username}",
		}:
			home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs {inherit system;};
				extraSpecialArgs = {inherit inputs username homeDirectory;};
				modules = [./home/default.nix];
			};
	in {
		nixosConfigurations = {
			wsl =
				nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = {inherit inputs;};
					modules = [
						nixos-wsl.nixosModules.default
						home-manager.nixosModules.home-manager
						./hosts/wsl/configuration.nix
					];
				};

			laptop =
				nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = {inherit inputs;};
					modules = [
						home-manager.nixosModules.home-manager
						./hosts/laptop/configuration.nix
					];
				};
		};

		homeConfigurations = {
			evanp = mkHome {username = "evanp";};
		};
	};
}
