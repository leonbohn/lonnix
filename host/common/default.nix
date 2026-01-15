{
  inputs,
  pkgs,
  age,
  nickName,
  secrets,
  ...
}:
{
  imports = [
    ./sops.nix
    ./ssh.nix
    ./podman.nix
    ./tailscale.nix
  ];

  # --- SYSTEM SETTINGS ---
  time.timeZone = "Europe/Berlin";
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

  # --- NIX SETTINGS ---
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "lonne"
      "remotebuild"
    ];
  };
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # --- USERS ---
  users.users.lonne = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.fish;
    # Included your hashed password from the Pi config as default
    hashedPassword = "$y$j9T$cKkgxZnGShRqC/VkOXPmZ1$0v4U3F98w9zzMYaHd1K0pGXzFnwONB/x9CexPYkmjU1";
  };

  users.users.remotebuild = {
    isSystemUser = true;
    group = "remotebuild";
    useDefaultShell = true;
  };
  users.groups.remotebuild = { };

  # --- SECRETS (Agenix) ---
  age.identityPaths = [ "/home/lonne/.ssh/id_ed25519" ];
  age.secrets.forgejo = {
    file = secrets + /forgejo.age;
    owner = "lonne"; # Ensures user can read the decrypted secret
  };

  # --- PROGRAMS ---
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/lonne/lonnix/";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.variables.EDITOR = "hx";

  environment.systemPackages = with pkgs; [
    sops
    ssh-to-age

    fish
    tmux
    jq
    starship
    eza
    bottom
    lazygit
    helix
    git
    wget
    ripgrep
    curl
    usbutils
    xz
    zip
    unzip
    unrar
    p7zip
    tree
    which
    gnupg
    nix-output-monitor
    just
    zellij
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default # Fixed architecture-specific agenix
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      starship init fish | source
      atuin init fish | source

      alias lg='lazygit'
      alias ls='eza'
      alias l='eza -a'
      alias buildpi='nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#lonnix-pi --system aarch64-linux -o ./pi.sd'
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1300;
      scan_timeout = 50;
      format = ''
        $all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status
        $username$hostname$directory'';
      character = {
        success_symbol = "[☑](bold green) ";
        error_symbol = "[X](bold red) ";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

}
