{
	description = "Evan's dendritic Nix configuration";

	inputs = {
		self.submodules = true;
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
		flake-parts = {
			url = "github:hercules-ci/flake-parts";
			inputs.nixpkgs-lib.follows = "nixpkgs";
		};
		import-tree.url = "github:vic/import-tree";
		nixos-wsl.url = "github:nix-community/NixOS-WSL";
		spotify-nixpkgs.url = "github:NixOS/nixpkgs/9ae611a455b90cf061d8f332b977e387bda8e1ca";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		mnw.url = "github:Gerg-L/mnw";
		nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
	};

	outputs = inputs:
		inputs.flake-parts.lib.mkFlake {
			inherit inputs;
			specialArgs = {
				packagesDir = ./packages;
				dotfilesRoot = ./..;
			};
		} (inputs.import-tree ./modules);
}
