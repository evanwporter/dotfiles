{
	config,
	homeDirectory,
	pkgs,
	...
}: let
	parserNames = [
		"bash"
		"typescript"
		"cmake"
		"cpp"
		"json"
		"toml"
		"nix"
		"make"
		"python"
		"rust"
		"toml"
		"ninja"
		"yaml"
		"fish"
		"systemverilog"
		"rst"
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
	xdg.configFile."nvim".source =
		config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/nvim";

	programs.neovim = {
		enable = true;
		defaultEditor = true;
		sideloadInitLua = true;

		extraWrapperArgs = [
			"--set"
			"NVIM_TREESITTER_PARSERS"
			"${treesitterParsers}"
			"--set"
			"NVIM_PLUGIN_MANAGER"
			"nix"
		];

		plugins = with pkgs.vimPlugins; [
			lz-n
			oil-nvim
			gruvbox-material
			fzf-lua
			which-key-nvim
			flash-nvim
			gitsigns-nvim
			conform-nvim
			nvim-treesitter
			nvim-treesitter-textobjects
			nvim-treesitter-context
			nvim-lspconfig
			mason-nvim-dap-nvim
			mason-nvim
			plenary-nvim
			nvim-dap
			neotest
		];

		extraPackages = with pkgs; [
			tree-sitter

			vscode-extensions.vadimcn.vscode-lldb
			vscode-langservers-extracted
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
			llvmPackages_22.clang-tools
			nodejs
			tombi
		];
	};
}
