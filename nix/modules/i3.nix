{
	services.xserver = {
		enable = true;

		windowManager.i3.enable = true;
	};

	services.displayManager.sddm.enable = true;

	networking.networkmanager = {
		enable = true;
	};
}
