{inputs, ...}: {
	flake.modules.nixos.nix-settings = {
		imports = [inputs.self.modules.nixos.nix-settings-base];
		nixpkgs.config.allowUnfree = true;
	};
}
