{...}: {
	flake.modules.nixos.pauseallmpv = {pkgs, ...}: {
		environment.systemPackages = [
			(pkgs.writeShellApplication {
					name = "pauseallmpv";
					runtimeInputs = [pkgs.socat];
					text = builtins.readFile ./pauseallmpv.sh;
				})
		];
	};
}
