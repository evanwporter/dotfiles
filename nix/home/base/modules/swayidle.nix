{
	lib,
	pkgs,
	osConfig ? null,
	...
}: let
	swayEnabled = osConfig != null && osConfig.programs.sway.enable;
	lockCommand =
		if osConfig.dotfiles.sway.desktopShell == "noctalia"
		then "noctalia msg session lock"
		else "${pkgs.swaylock}/bin/swaylock -f -c 303446";
in {
	services.swayidle =
		lib.mkIf swayEnabled {
			enable = true;
			timeouts = [
				{
					timeout = 240;
					command = "${pkgs.brightnessctl}/bin/brightnessctl --save set 40";
					resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl --restore";
				}
				{
					timeout = 300;
					command = lockCommand;
				}
				{
					timeout = 360;
					command = ''${pkgs.sway}/bin/swaymsg "output * power off"'';
					resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * power on"'';
				}
				{
					timeout = 1800;
					command = "${pkgs.systemd}/bin/systemctl suspend";
				}
			];
			events."before-sleep" = lockCommand;
		};
}
