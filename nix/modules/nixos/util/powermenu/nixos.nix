{...}: {
	flake.modules.nixos.powermenu = {pkgs, ...}: {
		environment.systemPackages = [
			(pkgs.writeShellApplication {
					name = "powermenu";
					runtimeInputs = [pkgs.mpc];
					text = builtins.readFile ./powermenu.sh;
				})
		];
	};
}
