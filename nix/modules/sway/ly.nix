{...}: let
	blackholeAnimation = ./blackhole.dur;
in {
	services.displayManager.ly = {
		enable = true;
		x11Support = false;
		settings = {
			animation = "dur_file";
			dur_file_path = toString blackholeAnimation;
			dur_offset_alignment = "center";
			full_color = true;
		};
	};
}
