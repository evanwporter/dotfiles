{
	description = "Evan's Nix config";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		nixos-wsl.url = "github:nix-community/NixOS-WSL";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs @ {
		nixpkgs,
		nixos-wsl,
		home-manager,
		nixvim,
		...
	}: let
		system = "x86_64-linux";

		mkHome = {
			username,
			homeDirectory ? "/home/${username}",
		}:
			home-manager.lib.homeManagerConfiguration {
				pkgs =
					import nixpkgs {
						inherit system;

						config.allowUnfree = true;
					};

				extraSpecialArgs = {
					inherit inputs username homeDirectory;
				};

				modules = [
					nixvim.homeModules.nixvim
					./home
				];
			};
	in {
		nixosConfigurations.nixos-wsl =
			nixpkgs.lib.nixosSystem {
				inherit system;

				specialArgs = {
					inherit inputs;
				};

				modules = [
					nixos-wsl.nixosModules.default
					home-manager.nixosModules.home-manager

					{
						home-manager.sharedModules = [
							nixvim.homeModules.nixvim
						];
					}

					./hosts/nixos-wsl/configuration.nix
				];
			};

		homeConfigurations = {
			evanw =
				mkHome {
					username = "evanw";
				};

			eporter =
				mkHome {
					username = "eporter";
				};
		};
	};
}
