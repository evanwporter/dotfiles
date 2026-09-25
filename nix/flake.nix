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
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		mnw.url = "github:Gerg-L/mnw";
		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
		nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
		duskwm = {
			url = "github:evanwporter/dusk";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		driftwm = {
			url = "github:malbiruk/driftwm";
			inputs.nixpkgs.follows = "nixpkgs";
		};
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
