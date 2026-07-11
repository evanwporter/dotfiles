{
	config,
	pkgs,
	...
}: let
	nvimSource = ../../../../nvim;
in {
	imports = [
		./config
	];

	xdg.configFile."nvim/lua".source =
		config.lib.file.mkOutOfStoreSymlink "/home/evanw/dotfiles/nvim/lua";

	programs.nixvim = {
		enable = true;
		defaultEditor = true;

		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		extraConfigLuaPost =
			builtins.readFile (nvimSource + "/init.lua");

		extraPackages = with pkgs; [
			vscode-extensions.vadimcn.vscode-lldb

			verible
			ruff
			stylua
			prettier
			alejandra
			cmake-format

			yaml-language-server
			lua-language-server
			nil
			pyright
			rust-analyzer
			neocmakelsp

			tree-sitter
		];
	};
}
