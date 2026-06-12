{
	description = "Evan's NixOS WSL config";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixos-wsl.url = "github:nix-community/NixOS-WSL";
	};

	outputs = {
		self,
		nixpkgs,
		nixos-wsl,
		...
	}: {
		nixosConfigurations.nixos =
			nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";

				modules = [
					nixos-wsl.nixosModules.default
					./configuration.nix
				];
			};
	};
}
