{config, ...}: {
	flake.modules.nixos.nix-settings = {
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
