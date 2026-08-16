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
	};
}
