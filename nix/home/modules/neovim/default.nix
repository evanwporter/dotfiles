{
	lib,
	pkgs,
	...
}: let
	nvimSource = ../../../../nvim;
	luaSource = nvimSource + "/lua";

	luaFiles = dir: prefix:
		lib.concatMapAttrs (name: type: let
			path =
				if prefix == ""
				then name
				else "${prefix}/${name}";
			source = dir + "/${name}";
		in
			if type == "directory"
			then luaFiles source path
			else if type == "regular" && lib.hasSuffix ".lua" name
			then {
				"${path}".source = source;
			}
			else {}) (builtins.readDir dir);
in {
	imports = [
		./config
	];

	programs.nixvim = {
		enable = true;
		defaultEditor = true;

		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		extraFiles = luaFiles luaSource "lua";

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
