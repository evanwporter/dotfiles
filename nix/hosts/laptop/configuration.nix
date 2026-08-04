# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
	inputs,
	pkgs,
	...
}: let
	spotifyPkgs =
		import inputs.spotify-nixpkgs {
			system = pkgs.stdenv.hostPlatform.system;
			config.allowUnfree = true;
		};
in {
	imports = [
		# Include the results of the hardware scan.
		./hardware-configuration.nix

		../../modules/nix.nix
		../../modules/firefox.nix
		../../modules/desktop-manager.nix
		# ../../modules/i3.nix
		../../modules/games
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "laptop"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Los_Angeles";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Enable sound with pipewire.
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.evanp = {
		isNormalUser = true;
		description = "Evan Porter";
		extraGroups = ["networkmanager" "wheel"];
		# packages = with pkgs; [
		# 	kdePackages.kate
		# 	#  thunderbird
		# ];
		shell = pkgs.fish;
	};

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;

		backupFileExtension = "hm-backup";

		extraSpecialArgs = {
			inherit inputs;
			username = "evanp";
			homeDirectory = "/home/evanp";
		};

		users.evanp = import ../../home/default.nix;
	};

	# Fonts configuration
	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	programs.fish.enable = true;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		wget
		neovim
		kitty
		tmux
		git
		obsidian
		spotifyPkgs.spotify
		surfer
	];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "26.05"; # Did you read the comment?

	environment.variables.TERMINAL = "kitty";
	xdg.terminal-exec = {
		enable = true;
		settings = {
			default = [
				"kitty.desktop"
			];
		};
	};

	# xresources.properties = {
	# 	"Xft.dpi" = 144;
	# };
}
