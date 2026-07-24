{pkgs, ...}: {
	programs.neovim = {
		enable = true;
		defaultEditor = true;

		extraPackages = with pkgs; [
			# Debug adapters
			vscode-extensions.vadimcn.vscode-lldb

			tree-sitter

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

		extraLuaConfig = ''
			vim.g.codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"
		'';
	};

	xdg.configFile."nvim" = {
		source = ../../nvim;
		recursive = true;
	};
}
