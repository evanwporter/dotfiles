{pkgs, ...}: {
	home.packages = with pkgs; [
		git
		gh
		delta
		lazygit
	];

	programs.git = {
		enable = true;

		settings = {
			user = {
				name = "Evan Porter";
				email = "evanwporter@gmail.com";
			};

			core = {
				editor = "nvim";
			};

			merge = {
				conflictStyle = "zdiff3";
			};

			"credential \"https://github.com\"" = {
				helper = "!gh auth git-credential";
			};
			"credential \"https://gist.github.com\"" = {
				helper = "!gh auth git-credential";
			};

			include = {
				path = "./.config/delta/themes.gitconfig";
			};
		};
	};

	programs.delta = {
		enable = true;
		enableGitIntegration = true;
		options = {
			features = "zenburn";
			navigate = true;
			side-by-side = true;
		};
	};

	# Make sure the GitHub CLI is authenticated automatically
	programs.gh.enable = true;
}
