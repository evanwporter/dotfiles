{...}: {
	flake.modules.homeManager.kanshi = {...}: {
		services.kanshi = {
			enable = true;
			settings = [
				{
					profile = {
						name = "laptop";
						outputs = [
							{
								criteria = "eDP-1";
								scale = 1.75;
							}
						];
					};
				}
			];
		};
	};
}
