{
	inputs,
	pkgs,
	...
}: {
	wsl.enable = true;
	wsl.defaultUser = "evanw";

	programs.nix-ld.enable = true;

	programs.fish.enable = true;

	users.users.evanw = {
		isNormalUser = true;
		extraGroups = ["wheel"];
		shell = pkgs.fish;
	};

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;

		backupFileExtension = "hm-backup";

		extraSpecialArgs = {
			inherit inputs;
			username = "evanw";
			homeDirectory = "/home/evanw";
		};

		users.evanw = import ../../home/default.nix;
	};

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
}
