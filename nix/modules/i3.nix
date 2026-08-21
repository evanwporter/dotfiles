{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		polybar
		pavucontrol
		libinput-gestures
	];

	services.xserver = {
		enable = true;
		# Scale the entire X11 desktop to roughly 150% (96 DPI is 100%).
		dpi = 192;

		windowManager.i3.enable = true;
	};

	services.libinput = {
		enable = true;
		touchpad.naturalScrolling = false;
	};

	services.displayManager.sddm.enable = true;

	networking.networkmanager = {
		enable = true;
	};
}
