{...}: {
	flake.modules.nixos.nx = {pkgs, ...}: {
		environment.systemPackages = [
			(pkgs.writeShellApplication {
					name = "nx";
					runtimeInputs = with pkgs; [
						jq
						gawk
						coreutils
					];
					text = builtins.readFile ./nx.sh;
				})
		];
	};
}
