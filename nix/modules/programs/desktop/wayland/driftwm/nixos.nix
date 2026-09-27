{inputs, ...}: {
	flake.modules.nixos.driftwm = {
		imports = [inputs.driftwm.nixosModules.default];
		programs.driftwm.enable = true;
	};
}
