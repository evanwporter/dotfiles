{...}: {
	flake.modules.homeManager.obsidian = {pkgs, ...}: {
		programs.obsidian = {
			enable = true;

			defaultSettings = {
				app = {
					alwaysUpdateLinks = true;
					attachmentFolderPath = "Attachments";
					newLinkFormat = "relative";
					useMarkdownLinks = true;
					vimMode = true;
				};

				# Appearance/theme is owned by the active khanelinix theme module
				# (modules/home/theme/<family>/apps.nix); do not set app.json
				# appearance or cssTheme here, since that would create a second
				# source of truth for the active theme family.
				hotkeys = {
					# Mirrors the zk `daily` alias: jump straight to today's note.
					# Upstream ships no default hotkey for this command.
					"daily-notes:goto-today" = [
						{
							modifiers = ["Mod"];
							key = "d";
						}
					];
				};
			};
		};
	};
}
