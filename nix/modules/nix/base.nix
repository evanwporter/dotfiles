{...}: {
	flake.modules.nixos.nix-settings-base = {
		nix.settings.experimental-features = [
			"nix-command"
			"flakes"
		];
	};
}
