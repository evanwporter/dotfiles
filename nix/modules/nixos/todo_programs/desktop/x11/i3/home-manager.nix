{...}: {
	flake.modules.homeManager.i3 = {
		lib,
		osConfig ? null,
		...
	}: {
		xdg.configFile =
			lib.mkIf (osConfig != null && osConfig.services.xserver.windowManager.i3.enable) {
				"i3/config".source = ./user.config;
				"i3/libinput-gestures.conf".source = ./libinput-gestures.conf;
			};
	};
}
