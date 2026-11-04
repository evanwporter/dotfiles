{
	inputs,
	modulesDir,
	...
}: {
	flake.modules.nixos.custom = import modulesDir;

	flake.modules.nixos.system-default = {
		imports = with inputs.self.modules.nixos; [
			nix-settings
			custom
		];
	};

	# Terminal Only Interface
	flake.modules.nixos.system-cli = {
		imports = [inputs.self.modules.nixos.system-default];
		programs.fish.enable = true;
	};

	# Graphical Desktop Interface
	flake.modules.nixos.system-desktop = {
		imports = with inputs.self.modules.nixos; [system-cli];
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
