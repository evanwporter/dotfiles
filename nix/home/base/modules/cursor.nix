{pkgs, ...}: {
	home.pointerCursor = {
		enable = true;
		name = "Adwaita";
		package = pkgs.adwaita-icon-theme;
		size = 24;
		gtk.enable = true;
		x11.enable = true;
	};
}
