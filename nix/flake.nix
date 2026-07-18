{
    description = "Evan's Nix config";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixos-wsl.url = "github:nix-community/NixOS-WSL";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
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
                pkgs = import nixpkgs { inherit system; };
                extraSpecialArgs = { inherit inputs username homeDirectory; };
                modules = [ ./home/default.nix ];
            };
    in {
        nixosConfigurations = {
            # Your existing WSL configuration
            wsl = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [
                    nixos-wsl.nixosModules.default
                    home-manager.nixosModules.home-manager
                    ./hosts/wsl/configuration.nix
                ];
            };

            # YOUR NEW FRESH INSTALL CONFIGURATION
            laptop = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [
                    home-manager.nixosModules.home-manager
                    ./hosts/laptop/configuration.nix
                ];
            };
        };

        homeConfigurations = {
            evanp = mkHome { username = "evanp"; };
        };
    };
}
