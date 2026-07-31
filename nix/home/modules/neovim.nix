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

	blink-lib =
		pkgs.vimUtils.buildVimPlugin {
			pname = "blink.lib";
			version = "5876dd95deeb70aadbe9f1c0b7117a135061cdac";
			src =
				pkgs.fetchFromGitHub {
					owner = "saghen";
					repo = "blink.lib";
					rev = "5876dd95deeb70aadbe9f1c0b7117a135061cdac";
					sha256 = "15zrgs89l8awxrdc59rmfvcc05j053q7cnpd21sgkpc3320drh0n";
				};
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
			nvim-treesitter-textobjects
			nvim-treesitter-context
			nvim-lspconfig
			plenary-nvim
			# nvim-dap
			neotest
			blink-cmp
			blink-lib
			blink-pairs
			blink-indent
			fff-nvim
			SchemaStore-nvim
			hardtime-nvim
			mini-icons
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
