{inputs, ...}: {
	flake.modules.homeManager.vscode = {
		config,
		lib,
		pkgs,
		...
	}: let
		cfg = config.development.vscode;
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
		options.development.vscode.enable = lib.mkEnableOption "VSCode development environment";

		config =
			lib.mkIf cfg.enable {
				programs.vscodium = {
					enable = true;
					package = pkgs.vscodium;

					mutableExtensionsDir = true;

					profiles.default.extensions = with marketplace; [
						(allowUnfreeExtension ms-vscode.cpptools)
						llvm-vs-code-extensions.vscode-clangd
						asvetliakov.vscode-neovim
						adam-bender.vscode-oldicons
						hudson-river-trading.vscode-slang
						matepek.vscode-catch2-test-adapter
						vsix.snrico-moonlight.gruvbox-material-community
					];
				};

				xdg.dataFile."icons/hicolor/512x512/apps/vscodium.png".source = "${pkgs.vscodium}/share/icons/hicolor/1024x1024/apps/vscodium.png";
			};
	};
}
