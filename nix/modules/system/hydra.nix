{
	flake.modules.nixos.hydra = {
		services.hydra = {
			enable = true;

			hydraURL = "http://localhost:3000";

			notificationSender = "hydra@localhost";

			# buildMachinesFiles = ["/etc/nix/machines"];

			useSubstitutes = true;
		};

		services.hydra-builder = {
			enable = true;

			queueRunnerAddr = "http://[::1]:50051";

			settings = {
				systems = ["x86_64-linux"];
				maxJobs = 4;
			};
		};

		nix.settings.allowed-uris = [
			"github:"
			"git+https://github.com/"
		];
	};
}
