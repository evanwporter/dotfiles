{
	description = "Evan";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixos-wsl.url = "github:nix-community/NixOS-WSL";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {
		nixpkgs,
		nixos-wsl,
		home-manager,
		...
	}: {
		nixosConfigurations.nixos =
			nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";

				modules = [
					nixos-wsl.nixosModules.default
					home-manager.nixosModules.home-manager
					./configuration.nix
				];
			};
	};
}
