# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      lonne = import ../../home/lonne;
    };
  };

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "end0";
    address = [
      "192.168.178.71/24"
    ];
    routes = [
      { Gateway = "192.168.178.1"; }
    ];
  };

  networking = {
    useNetworkd = true;
    dhcpcd.enable = false;

    hostName = "lonnix-pi";
    defaultGateway = {
      address = "192.168.178.1";
      interface = "end0";
    };
    nameservers = [
      "192.168.178.1"
    ];
  };

  users.users.lonne = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$y$j9T$cKkgxZnGShRqC/VkOXPmZ1$0v4U3F98w9zzMYaHd1K0pGXzFnwONB/x9CexPYkmjU1";
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  nix.settings.trusted-users = [ "lonne" ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  # i18n.defaultLocale = "de_DE.UTF-8";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    policies.SearchEngines.Add = [
      {
        # example numero uno
        Name = "NixOS Search";
        URLTemplate = "https://search.nixos.org/packages?channel=25.05&query={searchTerms}";
        Method = "GET"; # "POST"
        IconURL = "https://search.nixos.org/favicon.png";
      }
    ];
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/lonne/lonnix/";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish
    usbutils

    eza
    bottom

    lazygit

    helix
    git
    wget
    ripgrep
    curl

    rustc
    cargo
    cargo-binstall
  ];

  environment.variables.EDITOR = "hx";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
