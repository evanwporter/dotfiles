{pkgs, ...}: let
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
			vscode-langservers-extracted
			yaml-language-server
			lua-language-server
			stylua
			nil
			alejandra
			pyrefly
			rust-analyzer
			neocmakelsp
			prettier
			ruff
			cmake-format
			verible
			llvmPackages_22.clang-tools
			nodejs
			tombi
			bash-language-server
			shfmt
			shellcheck
			xmlstarlet
			marksman
		];
	};
}
