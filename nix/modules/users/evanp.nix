{inputs, ...}: let
	username = "evanp";
	homeDirectory = "/home/${username}";
in {
	flake.modules.nixos.evanp = {
		users.users.${username} = {
			isNormalUser = true;
			description = "Evan Porter";
			extraGroups = ["networkmanager" "wheel"];
		};
		home-manager.users.${username}.imports = [inputs.self.modules.homeManager.evanp];
	};

	flake.modules.homeManager.evanp = {
		imports = with inputs.self.modules.homeManager; [home-default shell development];
		home = {inherit username homeDirectory;};
	};

	flake.homeConfigurations.${username} =
		inputs.home-manager.lib.homeManagerConfiguration {
			pkgs =
				import inputs.nixpkgs {
					system = "x86_64-linux";
					config.allowUnfree = true;
				};
			modules = [inputs.self.modules.homeManager.${username}];
		};
}
