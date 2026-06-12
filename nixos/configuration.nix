# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
    imports = [
        # include NixOS-WSL modules
        <nixos-wsl/modules>
    ];

    wsl.enable = true;
    wsl.defaultUser = "nixos";

    programs.nix-ld.enable = true;

    programs.fish.enable = true;

    users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    };

    environment.systemPackages = with pkgs; [
        # editors / git
        git
        neovim
        lazygit
        gh
        delta

        # search / terminal tools
        ripgrep
        fd
        fzf
        curl
        wget
        unzip
        zip
        tree
        fish
        tmux
        bat

        # C / C++ build tools
        gcc
        clang
        cmake
        gnumake
        ninja
        pkg-config
        gdb
        lldb
        valgrind

        # useful libs/tools often needed by C/C++ projects
        openssl
        openssh
        zlib

        # language servers / formatters
        clang-tools
        cmake-language-server
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?
}

