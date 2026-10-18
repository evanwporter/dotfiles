{
	inputs,
	resourcesDir,
	config,
	...
}: let
	homeDirectory = "/home/${config.primaryUser}";
in {
	flake.modules.nixos.${config.primaryUser} = {pkgs, ...}: {
		users.users.${config.primaryUser} = {
			isNormalUser = true;
			description = "Evan Porter";
			extraGroups = ["networkmanager" "wheel"];
			shell = pkgs.fish;
		};
		home-manager.users.${config.primaryUser}.imports = [inputs.self.modules.homeManager.${config.primaryUser}];
	};

	flake.modules.homeManager.${config.primaryUser} = {...}: {
		# evanp could be multiple users on multiple systems so we only import the stuff
		# we know that we want availalable on every system for every user named evanp
		imports = with inputs.self.modules.homeManager; [home-default shell development];
		home = {
			inherit homeDirectory;
			username = "${config.primaryUser}";
		};
	};

	flake.homeConfigurations.${config.primaryUser} =
		inputs.home-manager.lib.homeManagerConfiguration {
			pkgs =
				import inputs.nixpkgs {
					system = "x86_64-linux";
					config.allowUnfree = true;
				};
			modules = [inputs.self.modules.homeManager.${config.primaryUser}];
			extraSpecialArgs = {
				inherit resourcesDir;
			};
		};
}
