{inputs, ...}: {
	flake.modules.nixos.gaming = {
		imports = [inputs.self.modules.nixos.steam];
	};
}
