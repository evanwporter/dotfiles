{...}: {
	flake.modules.homeManager.cursor = {pkgs, ...}: {
		# DWM does not provide the D-Bus Dconf service needed during system-level
		# Home Manager activation; GTK reads the generated settings.ini files.
		dconf.enable = false;
		gtk.enable = true;
		gtk.colorScheme = "dark";
		xresources.properties."Xft.dpi" = 192;

		home.pointerCursor = {
			enable = true;
			name = "Adwaita";
			package = pkgs.adwaita-icon-theme;
			# Keep GTK clients (notably Firefox) in sync with XCURSOR_SIZE in the
			# HiDPI DWM session.
			size = 60;
			gtk.enable = true;
			x11.enable = true;
		};
	};
}
