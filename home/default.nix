# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./mail.nix
    # ./mozilla.nix
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "leon";
    homeDirectory = "/home/leon";
  };

  home.packages = with pkgs; [
    xz
    zip
    unzip
    p7zip
    tree
    which
    gnupg
    nix-output-monitor
    zola
    spotify-player
    signal-desktop
    just

    nil # language server vor nix

    vscode
    unstable.zed-editor

    texliveFull

    ltex-ls-plus

    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-panel
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.just-perfection
  ];

  programs.thunderbird = {
    enable = true;
    profiles."leon" = {
      isDefault = true;
    };
  };


  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "León Bohn";
    userEmail = "bohn@lics.rwth-aachen.de";
  };

  programs.kitty = {
    enable = true;
    keybindings = {
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
    };
    extraConfig = ''
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      alias lg='lazygit'
      alias ls='eza'
      alias l='eza -a'
    '';
    plugins = [
      # { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
  };


  # programs.atuin = {
  #   enable = true;
  #   settings = {
  #     auto_sync = true;
  #     sync_frequency = "5m";
  #     sync_address = "https://api.atuin.sh";
  #     search_mode = "fuzzy";
  #   };
  # };

  programs.gpg.enable = true;
  programs.ssh = {
    enable = true;
    extraConfig = "
      Host *
        AddKeysToAgent yes
      Host pi 192.168.178.10
        HostName 192.168.178.10
        IdentityFile ~/.ssh/pi
        User leon
      Host vps 152.53.1.124
        HostName 152.53.1.124
        IdentityFile ~/.ssh/vps
        User leon
    ";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
