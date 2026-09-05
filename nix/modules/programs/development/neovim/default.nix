{
	dotfilesRoot,
	inputs,
	...
}: {
	flake.modules.homeManager.neovim = {
		config,
		lib,
		pkgs,
		...
	}: let
		cfg = config.dotfiles.neovim;
		nvimConfig =
			builtins.path {
				path = dotfilesRoot + "/nvim";
				name = "nvim-config";
			};

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
			"comment"
		];

		treesitterWithParsers =
			pkgs.vimPlugins.nvim-treesitter.withPlugins
			(parsers: map (name: parsers.${name}) parserNames);

		treesitterParsers =
			pkgs.symlinkJoin {
				name = "neovim-treesitter-parsers";
				paths = treesitterWithParsers.dependencies;
			};

		extraPackages = with pkgs; [
			tree-sitter
			vscode-extensions.vadimcn.vscode-lldb
			vscode-langservers-extracted
			yaml-language-server
			lua-language-server
			stylua
			nixd
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
			fish-lsp
			shfmt
			shellcheck
			xmlstarlet
			marksman
			slang-server
		];

		nixNeovim =
			inputs.mnw.lib.wrap pkgs {
				neovim =
					inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
							patches =
								(oldAttrs.patches or [])
								++ [
									./dashboard.patch
								];
						});
				luaFiles = [(nvimConfig + "/init.lua")];
				wrapperArgs = [
					# Available only to Neovim and processes it launches.
					"--prefix"
					"PATH"
					":"
					"${lib.makeBinPath extraPackages}"
					"--set"
					"NVIM_TREESITTER_PARSERS"
					"${treesitterParsers}"
					# "--set"
					# "CODELLDB_PATH"
					# "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"
				];

				plugins = {
					start = with pkgs.vimPlugins; [
						lazy-nvim
						nui-nvim
					];

					opt = with pkgs.vimPlugins; [
						nvim-lspconfig
						blink-cmp
						# blink-pairs
						blink-lib
						blink-indent
						friendly-snippets
						gitsigns-nvim
						image-nvim
						flash-nvim
						render-markdown-nvim
						vim-matchup
						mini-icons
						fzf-lua
						oil-nvim
						neotest
						nvim-rip-substitute
						conform-nvim
						nvim-surround
						yazi-nvim
						clangd_extensions-nvim
						which-key-nvim
						hardtime-nvim
						diffview-plus-nvim
						nvim-dap
						nvim-dap-view
						nvim-treesitter-context
						nvim-treesitter-textobjects
						nvim-dap-virtual-text
						grug-far-nvim
						# nui-nvim
						nvim-nio
						gruvbox-material
						lazydev-nvim
						copilot-lua
						blink-copilot
						rustaceanvim
						trouble-nvim
						vim-matchup
						slang-server-nvim
						nvim-lint
						vim-tmux-navigator
					];

					optAttrs = {
						fff = pkgs.vimPlugins.fff-nvim;
						harpoon = pkgs.vimPlugins.harpoon2;
						schemastore-nvim = pkgs.vimPlugins.SchemaStore-nvim;
					};

					dev.myconfig = {
						pure = nvimConfig;
						impure = "${config.home.homeDirectory}/dotfiles/nvim";
					};
				};
			};
	in {
		options.dotfiles.neovim = {
			packageManager =
				lib.mkOption {
					type = lib.types.enum ["lazy" "nix"];
					default = "nix";
					description = "Use normal lazy.nvim bootstrap or an mnw-wrapped Neovim.";
				};

			finalPackage =
				lib.mkOption {
					type = lib.types.package;
					readOnly = true;
					default = nixNeovim;
					internal = true;
				};
		};

		config =
			lib.mkMerge [
				(lib.mkIf (cfg.packageManager == "lazy") {
						programs.neovim = {
							enable = true;
							defaultEditor = true;
							sideloadInitLua = true;

                            # inherit here is shorthand for
                            # extraPackages = extraPackages;
							inherit extraPackages;
						};
					})

				(lib.mkIf (cfg.packageManager == "nix") {
						home.packages = [nixNeovim];
						home.sessionVariables.NVIM_TREESITTER_PARSERS = "${treesitterParsers}";
					})
			];
	};
}
