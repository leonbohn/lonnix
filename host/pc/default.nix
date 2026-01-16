# lonnix-pc configuration file
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../runner.nix

    ./kde.nix
  ];

  # Bootloader & Emulation
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd.luks.devices."luks-d5e498c1-4a23-476b-ac9c-61297e991ae2".device =
      "/dev/disk/by-uuid/d5e498c1-4a23-476b-ac9c-61297e991ae2";
  };
  # Networking
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp34s0";
    address = [ "192.168.178.61/24" ];
    routes = [ { Gateway = "192.168.178.1"; } ];
  };

  # GUI & Services
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    policies.SearchEngines.Add = [
      {
        # example numero uno
        Name = "NixOS Search";
        URLTemplate = "https://search.nixos.org/packages?channel=25.11&query={searchTerms}";
        Method = "GET"; # "POST"
        IconURL = "https://search.nixos.org/favicon.png";
      }
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    clang
    rustc
    cargo
    cargo-binstall
    # rewrite of SQLite in Rust
    turso-cli

    zotero
    obsidian
    nextcloud-client

    ungoogled-chromium

    tor-browser

    wl-clipboard
    jdk
    typst
    vlc

    spotify-player
    signal-desktop

    mattermost-desktop

    vscode
    zed-editor

    texliveFull

    inkscape
    inkscape-with-extensions

    flutter
    android-studio
    android-tools
    androidsdk
    # android-sdk-platform-tools
    # android-sdk-emulator
    # androidenv.androidPkgs.platform-tools

    openconnect

    nil # language server for nix
    nixfmt-classic
    nixd

    ltex-ls-plus
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # services.mullvad-vpn = {
  #   enable = true;
  #   package = pkgs.mullvad-vpn;
  # };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  programs.adb.enable = true;

  services.udev.extraRules = ''
    # enable wake on USB for keyboard
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="01e0", ATTR{power/wakeup}="enabled"
  '';
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

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
  system.stateVersion = "25.11"; # Did you read the comment?

}
