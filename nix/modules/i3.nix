{
	services.xserver = {
		enable = true;

		windowManager.i3.enable = true;
	};

	services.displayManager.sddm.enable = true;

	programs.networkmanager = {
		enable = true;
	};
}
