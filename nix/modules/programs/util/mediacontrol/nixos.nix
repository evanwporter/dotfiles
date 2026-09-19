{...}: {
	flake.modules.homeManager.mediacontrol = {pkgs, ...}: {
		home.packages = [
			(pkgs.writeShellApplication {
					name = "mediacontrol";
					runtimeInputs = [pkgs.mpc];
					text = builtins.readFile ./mediacontrol.sh;
				})
		];
	};
}
