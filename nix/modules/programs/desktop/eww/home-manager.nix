{inputs, ...}: {
	flake.modules.homeManager.eww = {pkgs, ...}: {
		imports = with inputs.self.modules.homeManager; [mediacontrol];
		programs.eww = {
			enable = true;
			package = pkgs.eww;
			yuckConfig = builtins.readFile ./eww/eww.yuck;
			scssConfig = builtins.readFile ./eww/eww.scss;
		};

		# xdg.configFile = {
		# 	"eww/var.yuck".source = ./eww/var.yuck;
		# 	"eww/src".source = ./eww/src;
		# 	"eww/scss".source = ./eww/scss;
		# 	"eww/scripts".source = ./eww/scripts;
		# 	"eww/config".source = ./eww/config;
		# };
	};
}
