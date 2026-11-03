{inputs, ...}: {
	flake.modules.homeManager.wayland = {...}: {
		imports = [
			inputs.self.modules.homeManager.kanshi
		];
	};
}
