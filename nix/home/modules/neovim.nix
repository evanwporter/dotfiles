{pkgs, ...}: {
	programs.neovim = {
		enable = true;
		defaultEditor = true;

		extraPackages = with pkgs; [
			# Debug adapters
			vscode-extensions.vadimcn.vscode-lldb

			tree-sitter
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
