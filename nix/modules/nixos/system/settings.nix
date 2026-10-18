{config, inputs, ...}: {
	flake.modules.nixos.nix-settings = {
		nixpkgs.overlays = [inputs.self.overlays.default];
		nixpkgs.config.allowUnfree = true;
		nix.settings.trusted-users = ["root" "${config.primaryUser}"];
		nix.settings.experimental-features = [
			"nix-command"
			"flakes"
			"ca-derivations"
			"recursive-nix"
		];
	};
}
