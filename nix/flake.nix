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

		noctalia = {
			url = "github:noctalia-dev/noctalia";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
	};

	outputs = inputs @ {
		nixpkgs,
		nixos-wsl,
		home-manager,
		...
	}: let
		system = "x86_64-linux";
		dotfilesRoot = ./..;
		pkgs =
			import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};

		mkSystem = {
			hostname,
			username,
			homeDirectory ? "/home/${username}",
			extraModules ? [],
		}:
			nixpkgs.lib.nixosSystem {
				inherit system;

				specialArgs = {
					inherit inputs username homeDirectory dotfilesRoot;
				};

				modules =
					[
						home-manager.nixosModules.home-manager
						./hosts/${hostname}/configuration.nix
					]
					++ extraModules;
			};

		mkHome = {
			username,
			homeDirectory ? "/home/${username}",
		}:
			home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = {inherit inputs username homeDirectory dotfilesRoot;};
				modules = [./home/base/default.nix];
			};

		homeConfigurations = {
			evanp = mkHome {username = "evanp";};
		};

		neovimDev = homeConfigurations.evanp.config.dotfiles.neovim.finalPackage.devMode;
	in {
		inherit homeConfigurations;

		packages.${system}.neovim-dev = neovimDev;

		apps.${system}.neovim-dev = {
			type = "app";
			program = "${neovimDev}/bin/nvim";
		};

		devShells.${system}.default =
			pkgs.mkShell {
				packages = [neovimDev];
			};

		nixosConfigurations = {
			laptop =
				mkSystem {
					hostname = "laptop";
					username = "evanp";
				};

			wsl =
				mkSystem {
					hostname = "wsl";
					username = "evanw";
					extraModules = [
						nixos-wsl.nixosModules.default
					];
				};
		};
	};
}
