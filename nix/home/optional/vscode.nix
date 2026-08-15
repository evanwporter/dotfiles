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
in {
	programs.vscodium = {
		enable = true;
		package = pkgs.vscodium-fhs;

		mutableExtensionsDir = true;

		profiles.default.extensions = with marketplace; [
			(allowUnfreeExtension ms-vscode.cpptools)
			llvm-vs-code-extensions.vscode-clangd
			vscodevim.vim
			adam-bender.vscode-oldicons
			hudson-river-trading.vscode-slang
		];
	};
}
