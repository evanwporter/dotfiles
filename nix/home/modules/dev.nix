{pkgs, ...}: {
	home.packages = with pkgs; [
		# # build tools
		# gcc16
		# clang_22
		# cmake
		# gnumake
		# ninja
		# pkg-config
		# gdb
		# lldb
		# valgrind
		# vcpkg
		#
		# # node/npm
		# nodejs
		# # corepack
		# typescript
		#
		# # hdl tools
		# verilator
		#
		# # # language services
		# llvmPackages_22.clang-tools
		#
		# # # python
		# python313
		# python313Packages.pip
		#
		# # # rust / cargo
		# rustc
		# cargo
		# clippy
		# rustfmt
	];
}
