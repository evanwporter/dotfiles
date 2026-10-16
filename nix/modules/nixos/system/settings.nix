{
	flake.modules.nixos.nix-settings = {
		nixpkgs.config.allowUnfree = true;
		nix.settings.trusted-users = ["root" "evanp"];
		nix.settings.experimental-features = [
			"nix-command"
			"flakes"
		];
	};
}
