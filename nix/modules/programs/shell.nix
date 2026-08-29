{inputs, ...}: {
	flake.modules.homeManager.shell = {
		imports = [inputs.self.modules.homeManager.fish];
	};
}
