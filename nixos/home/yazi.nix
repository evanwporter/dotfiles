{pkgs, ...}: {
	home.file.".local/bin/yazi-nvim" = {
		executable = true;

		text = ''
			#!${pkgs.runtimeShell}

			find_git_root() {
			  dir="$1"

			  while [ "$dir" != "/" ]; do
			    if [ -d "$dir/.git" ]; then
			      printf '%s\n' "$dir"
			      return 0
			    fi

			    dir="$(${pkgs.coreutils}/bin/dirname -- "$dir")"
			  done

			  return 1
			}

			if [ "$#" -eq 1 ] && [ -d "$1" ]; then
			  cd "$1" || exit 1
			  exec ${pkgs.neovim}/bin/nvim .
			fi

			if [ "$#" -ge 1 ] && [ -f "$1" ]; then
			  real="$(${pkgs.coreutils}/bin/realpath -- "$1")"
			  file_dir="$(${pkgs.coreutils}/bin/dirname -- "$real")"

			  if git_root="$(find_git_root "$file_dir")"; then
			    cd "$git_root" || exit 1
			  else
			    cd "$file_dir" || exit 1
			  fi
			fi

			exec ${pkgs.neovim}/bin/nvim "$@"
		'';
	};
}
