# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  lib,
  config,
  user,
  pkgs,
  osConfig,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    ./ssh.nix
    ./mail.nix
    ./helix.nix
    ./git.nix
    # ./mozilla.nix
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  home = {
    username = user;
    homeDirectory = lib.mkForce "/home/${user}";
  };

  home.packages = with pkgs; [
    fish
    jq
    fzf
    eza
    bat
    fd
  ];

  programs.thunderbird = {
    enable = true;
    profiles.${user} = {
      isDefault = true;
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

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
      session_path = osConfig.sops.secrets.atuinsession.path;
      key_path = osConfig.sops.secrets.atuinkey.path;
    };
  };

  programs.gpg.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
