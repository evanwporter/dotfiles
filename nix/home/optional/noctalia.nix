{inputs, ...}: let
	wallpaper = ../../../sway/tf2.jpg;
in {
	imports = [inputs.noctalia.homeModules.default];

	programs.noctalia = {
		enable = true;

		settings = {
			config_version = 12;

			bar.default = {
				color = "primary";
				concave_edge_corners = false;
				end = ["tray" "bluetooth" "network" "volume" "battery" "session"];
				font_family = "MonaspiceNe Nerd Font";
				icon_color = "primary";
				margin_ends = 0;
				padding = 10;
				radius = 0;
				start = ["workspaces"];
				thickness = 20;
				widget_spacing = 10;
			};

			dock.show_dots = true;
			location.auto_locate = true;

			lockscreen = {
				blur_intensity = 0.0;
				wallpaper = "${wallpaper}";
			};

			lockscreen_widgets = {
				enabled = true;
				schema_version = 2;
				widget_order = [
					"lockscreen-login-box@eDP-1"
					"lockscreen-widget-0000000000000001"
					"lockscreen-widget-0000000000000002"
				];

				grid = {
					cell_size = 24;
					major_interval = 4;
					visible = true;
				};

				widget."lockscreen-login-box@eDP-1" = {
					box_height = 70.0;
					box_width = 336.0;
					cx = 960.0;
					cy = 695.0;
					output = "eDP-1";
					rotation = 0.0;
					type = "login_box";
					settings = {
						background_color = "surface_variant";
						background_opacity = 0.0;
						background_radius = 10.0;
						center_password_text = true;
						input_opacity = 1.0;
						input_radius = 6.0;
						layout = "compact";
						show_caps_lock = true;
						show_keyboard_layout = false;
						show_login_button = false;
						show_media = true;
						show_session_buttons = true;
						show_unlock_hint = true;
						show_weather = true;
					};
				};

				widget."lockscreen-widget-0000000000000001" = {
					box_height = 56.0;
					box_width = 176.0;
					cx = 960.0;
					cy = 444.0;
					output = "eDP-1";
					rotation = 0.0;
					type = "clock";
					settings = {
						background_opacity = 0.0;
						background_padding = 3;
						background_radius = 10;
						clock_style = "digital";
						font_family = "MonaspiceKr Nerd Font";
						format = "{:%-I:%M %p}";
					};
				};

				widget."lockscreen-widget-0000000000000002" = {
					box_height = 64.0;
					box_width = 648.0;
					cx = 960.0;
					cy = 372.0;
					output = "eDP-1";
					rotation = 0.0;
					type = "clock";
					settings = {
						background_opacity = 0.0;
						background_padding = 3;
						background_radius = 10;
						font_family = "MonaspiceKr Nerd Font";
						format = "{:%A %d %B %Y}";
					};
				};
			};

			shell = {
				app_icon_color = "error";
				font_family = "MonaspiceNe NF";
				polkit_agent = true;
				launcher.categories = false;
			};

			theme = {
				mode = "dark";
				source = "wallpaper";
				wallpaper_scheme = "m3-rainbow";
			};

			wallpaper = {
				directory = builtins.dirOf "${wallpaper}";
				fill_mode = "span";
				transition_on_startup = true;
				automation.recursive = false;
				default.path = "${wallpaper}";
				last.path = "${wallpaper}";
				monitors."eDP-1".path = "${wallpaper}";
			};

			widget.clock.format = "{:%A %-e %B %Y %-I:%M %P}";
		};
	};
}
