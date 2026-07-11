{
	pkgs,
	lib,
	...
}: let
	parserNames = [
		"bash"
		"c"
		"cmake"
		"json"
		"nix"
		"python"
		"rust"
		"toml"
		"yaml"
	];

	treesitterWithParsers =
		pkgs.vimPlugins.nvim-treesitter.withPlugins
		(parsers: map (name: parsers.${name}) parserNames);

	treesitterParsers =
		pkgs.symlinkJoin {
			name = "neovim-treesitter-parsers";
			paths = treesitterWithParsers.dependencies;
		};
in {
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		sideloadInitLua = true;

		extraWrapperArgs = [
			"--set"
			"NVIM_TREESITTER_PARSERS"
			"${treesitterParsers}"
		];

		extraPackages = with pkgs; [
			tree-sitter

			vscode-extensions.vadimcn.vscode-lldb
			yaml-language-server
			lua-language-server
			stylua
			nil
			alejandra
			pyright
			rust-analyzer
			neocmakelsp
			prettier
			ruff
			cmake-format
			verible
		];
	};
}
