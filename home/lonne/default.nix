# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
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

  home = {
    username = "lonne";
    homeDirectory = lib.mkForce "/home/lonne";
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

    nil # language server for nix
    nixfmt-classic

    vscode
    # unstable.zed-editor

    texliveFull

    ltex-ls-plus

    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-panel
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.just-perfection
  ];

  programs.thunderbird = {
    enable = true;
    profiles."lonne" = { isDefault = true; };
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
    extraConfig = "";
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
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
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
    extraConfig =
      "\n      Host *\n        AddKeysToAgent yes\n      Host pi 192.168.178.10\n        HostName 192.168.178.10\n        IdentityFile ~/.ssh/pi\n        User leon\n      Host vps 152.53.1.124\n        HostName 152.53.1.124\n        IdentityFile ~/.ssh/vps\n        User leon\n    ";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
