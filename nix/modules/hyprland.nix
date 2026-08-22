{...}: {
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	# Noctalia uses these services for its network, Bluetooth, battery, and
	# power-profile widgets.
	hardware.bluetooth.enable = true;
	services.power-profiles-daemon.enable = true;
	services.upower.enable = true;
}
