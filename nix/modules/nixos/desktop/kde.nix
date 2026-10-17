{...}: {
	flake.modules.nixos.kde = {pkgs, ...}: {
		config = {
			# Enable the X11 windowing system
			services.xserver.enable = true;

			# Enable SDDM and KDE Plasma 6
			services.displayManager.sddm.enable = true;
			services.desktopManager.plasma6.enable = true;

			# Exclude bloat
			environment.plasma6.excludePackages = with pkgs.kdePackages; [
				kate
				konsole
			];

			environment.systemPackages = with pkgs; [zoom-us];
		};
	};
}
