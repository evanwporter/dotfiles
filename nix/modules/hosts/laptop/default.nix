{
	config,
	inputs,
	lib,
	...
}: let
	system = "x86_64-linux";
	personality = config.hosts.laptop.personality;
in {
	options.hosts.laptop.personality =
		lib.mkOption {
			type = lib.types.enum ["dwm" "kde"];
			description = "Desktop personality used by the laptop.";
		};

	config = {
		hosts.laptop.personality = lib.mkDefault "dwm";

		flake.modules.nixos.laptop = {
			imports = [
				./_hardware.nix
				inputs.self.modules.nixos."personality-${personality}"
				inputs.self.modules.nixos.gaming
				inputs.self.modules.nixos.evanp
			];
		};

		flake.nixosConfigurations.laptop =
			inputs.nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					inputs.home-manager.nixosModules.home-manager
					inputs.self.modules.nixos.laptop
				];
			};
	};
}
