{lib, ...}: {
	options = {
		# Some stuff on this page is from:
		# https://github.com/GaetanLepage/nix-config/blob/96e785dcb2e14e6b87c44a821c2bab687b32e562/modules/flake/hosts/_utils/base.nix
		primaryUser =
			lib.mkOption {
				type = lib.types.str;
				default = "evanp";
				description = ''
					The primary user of the computer. They shall be a trusted user in Nix
					and the home manager configuration will be associated with them.
				'';
			};

		system =
			lib.mkOption {
				type =
					lib.types.enum [
						"x86_64-linux"
						"aarch64-linux"
						"i686-linux"
						"armv7l-linux"
						"x86_64-darwin"
						"aarch64-darwin"
					];
				default = "x86_64-linux";
				description = "Target system architecture and OS.";
			};
	};
}
