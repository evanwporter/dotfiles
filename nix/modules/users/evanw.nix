{inputs, ...}: let
	username = "evanw";
	homeDirectory = "/home/${username}";
in {
	flake.modules.nixos.evanw = {
		home-manager = {
			useGlobalPkgs = true;
			useUserPackages = true;
			backupFileExtension = "hm-backup";
		};
		users.users.${username} = {
			isNormalUser = true;
			extraGroups = ["wheel"];
		};
		home-manager.users.${username}.imports = [inputs.self.modules.homeManager.evanw];
	};

	flake.modules.homeManager.evanw = {
		imports = with inputs.self.modules.homeManager; [home-default shell development];
		home = {inherit username homeDirectory;};
	};
}
