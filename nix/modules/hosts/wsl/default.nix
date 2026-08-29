{inputs, ...}: {
	flake.modules.nixos.wsl = {pkgs, ...}: {
		imports = with inputs.self.modules.nixos; [
			personality-minimal
			evanw
			inputs.nixos-wsl.nixosModules.default
		];

		wsl = {
			enable = true;
			defaultUser = "evanw";
		};
		programs.nix-ld.enable = true;
		environment.systemPackages = with pkgs; [
			git
			curl
			wget
			unzip
			zip
			file
			openssh
		];
		system.stateVersion = "26.05";
	};

	flake.nixosConfigurations.wsl =
		inputs.nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				inputs.home-manager.nixosModules.home-manager
				inputs.self.modules.nixos.wsl
			];
		};
}
