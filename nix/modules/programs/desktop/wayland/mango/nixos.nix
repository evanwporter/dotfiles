{inputs, ...}: {
	flake.modules.nixos.mango = {pkgs, ...}: {
		programs.mango.enable = true;

		home-manager.sharedModules = with inputs.self.modules.homeManager; [
			mango
		];

		environment.systemPackages = with pkgs; [
			foot
			wmenu
			wl-clipboard
			flameshot
			slurp
			swaybg
			firefox
		];
	};
}
