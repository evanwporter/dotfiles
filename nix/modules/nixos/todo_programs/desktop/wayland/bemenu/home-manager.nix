{...}: {
	flake.modules.homeManager.bemenu = {pkgs, ...}: {
		home.packages = with pkgs; [
			bemenu
		];

		home.sessionVariables.BEMENU_OPTS = "-i --tb='#222222' --tf='#bbbbbb' --fb='#222222' --nb='#222222' --nf='#bbbbbb' --hb='#005577' --hf='#eeeeee' -p ''";
	};
}
