{inputs, ...}: {
	flake.modules.nixos.browser = {
		imports = [inputs.self.modules.nixos.firefox];
	};
}
