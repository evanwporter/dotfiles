{
	inputs,
	pkgs,
	...
}: let
	marketplace =
		inputs.nix-vscode-extensions.extensions
			.${pkgs.stdenv.hostPlatform.system}
			.vscode-marketplace-release;
	allowUnfreeExtension = extension:
		extension.overrideAttrs (old: {
				meta = old.meta // {license = [];};
			});

	vsix = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.open-vsx-release;
in {
	programs.vscodium = {
		enable = true;
		package = pkgs.vscodium-fhs;

		mutableExtensionsDir = true;

		profiles.default.extensions = with marketplace; [
			(allowUnfreeExtension ms-vscode.cpptools)
			llvm-vs-code-extensions.vscode-clangd
			asvetliakov.vscode-neovim
			adam-bender.vscode-oldicons
			hudson-river-trading.vscode-slang
			matepek.vscode-catch2-test-adapter
			# sainnhe.gruvbox-material
			vsix.snrico-moonlight.gruvbox-material-community
		];

		# profiles.default.settings = {
		# 	"workbench.colorTheme" = "Gruvbox Material Dark";
		# 	"workbench.iconTheme" = "vscode-oldicons";
		# 	# "editor.fontFamily" = "Fira Code";
		# 	# "editor.fontLigatures" = true;
		# 	# "editor.fontSize" = 14;
		# 	# "editor.lineHeight" = 22;
		# 	# "editor.tabSize" = 4;
		# 	# "editor.detectIndentation" = false;
		# 	# "editor.renderWhitespace" = "all";
		# 	# "editor.renderControlCharacters" = true;
		# 	# "editor.minimap.enabled" = false;
		# 	# "editor.cursorBlinking" = "smooth";
		# 	# "editor.cursorSmoothCaretAnimation" = true;
		# };
	};

	xdg.dataFile."icons/hicolor/512x512/apps/vscodium.png".source = "${pkgs.vscodium}/share/icons/hicolor/1024x1024/apps/vscodium.png";
}
