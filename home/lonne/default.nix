# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  secrets,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    ./mail.nix
    ./cal.nix
    ./helix.nix
    # ./mozilla.nix
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    inputs.agenix.homeManagerModules.default
  ];

  home = {
    username = "lonne";
    homeDirectory = lib.mkForce "/home/lonne";
  };

  home.packages = with pkgs; [
    spotify-player
    signal-desktop

    mattermost-desktop

    nil # language server for nix
    nixfmt-classic
    nixd

    vscode
    zed-editor

    texliveFull

    ltex-ls-plus

    flatpak
    gnome-software
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
    settings = {
      user = {
        name = "León Bohn";
        email = "bohn@lics.rwth-aachen.de";
      };
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
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
      "cmd+shift+t" = "new_tab_with_cwd";
    };
    extraConfig = "";
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "fuzzy";
      session_path = config.age.secrets.atuinsession.path;
      key_path = config.age.secrets.atuinkey.path;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = { };

    extraConfig = "\n      Host *\n        AddKeysToAgent yes\n      Host pi 192.168.178.10\n        HostName 192.168.178.10\n        IdentityFile ~/.ssh/pi\n        User leon\n      Host vps 152.53.1.124\n        HostName 152.53.1.124\n        IdentityFile ~/.ssh/vps\n        User leon\n";
  };

  programs.gpg.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";

  age = {
    secrets = {
      mail.file = secrets + /mail.age;
      radicale.file = secrets + /radicale.age;
      atuinkey.file = secrets + /atuinkey.age;
      forgejo.file = secrets + /forgejo.age;
      atuinsession.file = secrets + /atuinsession.age;
    };
    # identityPaths = [ "${config.home.homeDirectory}/.ssh" ];
    # secretsDir = "${config.home.homeDirectory}/.agenix";
  };

}
