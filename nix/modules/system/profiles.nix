{
	inputs,
	lib,
	...
}: {
	flake.modules.nixos.system-default = {
		imports = [inputs.self.modules.nixos.nix-settings];
	};

	# Terminal Only Interface
	flake.modules.nixos.system-cli = {
		imports = [inputs.self.modules.nixos.system-default];
		programs.fish.enable = true;
	};

	# Graphical Desktop Interface
	flake.modules.nixos.system-desktop = {
		imports = with inputs.self.modules.nixos; [system-cli];
		options.host = {
			personality =
				lib.mkOption {
				type = lib.types.enum ["dwm" "dusk" "sway" "niri"];
				default = "dusk";
					description = "Desktop environment personality for this host.";
				};
		};
		config = {
			services.printing.enable = true;
			services.pulseaudio.enable = false;
			security.rtkit.enable = true;
			services.pipewire = {
				enable = true;
				alsa.enable = true;
				alsa.support32Bit = true;
				pulse.enable = true;
			};
		};
	};
}
