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
			type = lib.types.enum ["driftwm" "dwm" "dusk" "kde" "sway"];
			description = "Desktop personality used by the laptop.";
		};

	config = {
		hosts.laptop.personality = lib.mkDefault "dwm";

		flake.modules.nixos.laptop = {
			home-manager.users.evanp.imports = with inputs.self.modules.homeManager; [
				graphical
				btop
				vscode
				helix
				zed
			];

			imports = with inputs.self.modules.nixos; [
				./_hardware.nix
				inputs.self.modules.nixos."personality-${personality}"
				gaming
				evanp
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
