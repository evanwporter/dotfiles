{inputs, ...}: {
	flake.modules.nixos.mango = {pkgs, ...}: let
		mangoSessionInit = pkgs.writeShellScriptBin "mango-session-init" ''
			# Mango has established the Wayland socket by the time exec_once runs.
			# Make it available to user services before starting Kanshi.
			${pkgs.systemd}/bin/systemctl --user import-environment \
				WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP
			${pkgs.systemd}/bin/systemctl --user start kanshi.service
		'';
	in {
		programs.mango.enable = true;

		home-manager.sharedModules = with inputs.self.modules.homeManager; [
			mango
			kanshi
		];

		environment.systemPackages = with pkgs; [
			mangoSessionInit
			foot
			wmenu
			wl-clipboard
			flameshot
			slurp
			swaybg
			firefox
		];
	};
}
