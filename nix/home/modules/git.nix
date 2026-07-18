{pkgs, ...}: {
	# Ensure these packages are available in your user environment
	home.packages = with pkgs; [
		gh
		delta
	];

	programs.git = {
		enable = true;
		userName = "Evan Porter";
		userEmail = "evanwporter@gmail.com";

		# This automatically sets up your delta integration
		delta = {
			enable = true;
			options = {
				features = "zenburn";
				navigate = true;
				side-by-side = true;
			};
		};

		extraConfig = {
			core.editor = "nvim";
			merge.conflictStyle = "zdiff3";

			# Use the 'gh' CLI tool properly without hardcoded store paths
			"credential \"https://github.com\"" = {
				helper = "!gh auth git-credential";
			};
			"credential \"https://gist.github.com\"" = {
				helper = "!gh auth git-credential";
			};

			# If you have custom themes, keep the include path
			include.path = "./.config/delta/themes.gitconfig";
		};
	};

	# Make sure the GitHub CLI is authenticated automatically
	programs.gh.enable = true;
}
