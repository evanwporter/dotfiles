{inputs, ...}: {
	flake.modules.nixos.niri = {pkgs, ...}: {
		imports = with inputs.self.modules.nixos; [polkit];

		programs.niri.enable = true;

		environment.etc."niri/config.kdl".source = ./system.kdl;

		home-manager.sharedModules = with inputs.self.modules.homeManager; [
			mango
		];

		environment.systemPackages = with pkgs; [
			brightnessctl
			fuzzel
			libnotify
			mako
			pavucontrol
			swayidle
			swaybg
			swaylock
			xwayland-satellite
		];
	};
}
