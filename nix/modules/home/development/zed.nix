{...}: {
	flake.modules.homeManager.zed = {...}: {
		programs.zed-editor = {
			enable = true;
			extensions = ["nix" "toml" "rust" "Gruvbox Material"];
			userSettings = {
				theme = {
					mode = "dark";
					dark = "Gruvbox Material";
					light = "One Light";
				};
				hour_format = "hour24";
				vim_mode = true;
			};
		};
	};
}
