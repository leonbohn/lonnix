{
  inputs,
  config,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    ./ssh.nix
  ];

  users.users.remotebuild = {
    isSystemUser = true;
    group = "remotebuild";
    useDefaultShell = true;

    # openssh.authorizedKeys.keyFiles =  [ ];
  };

  users.groups.remotebuild = { };
  nix.settings.trusted-users = [ "remotebuild" ];
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';

  environment.systemPackages =
    with pkgs;
    [
      fish
      tmux
      jq
      starship

      usbutils
      eza
      xz
      zip
      unzip
      p7zip
      tree
      which
      gnupg
      nix-output-monitor
      just
      bottom

      zellij

      lazygit
      git
      wget
      ripgrep
      curl

    ]
    ++ [ inputs.agenix.packages.x86_64-linux.default ];

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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1300;
      scan_timeout = 50;
      format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
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

  age.identityPaths = [ "/home/lonne/.ssh/id_ed25519" ];
  age.secrets.forgejo.file = ../../secrets/forgejo.age;

  # age = {
  #   secrets = {
  #     mail.file = secrets + /mail.age;
  #     radicale.file = secrets + /radicale.age;
  #     atuinkey.file = secrets + /atuinkey.age;
  #     forgejo.file = secrets + /forgejo.age;
  #     atuinsession.file = secrets + /atuinsession.age;
  #   };
  #   identityPaths = [ "/home/lonne/.ssh" ];
  #   # secretsDir = "${config.home.homeDirectory}/.agenix";
  # };
}
