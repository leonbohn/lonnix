{ pkgs, config, ... }:

let
  customCiImage = pkgs.dockerTools.streamLayeredImage {
    name = "forgejo-nix-node-runner";
    tag = "latest";
    contents = with pkgs; [
      bashInteractive
      coreutils
      git
      cacert
      nix
      nodejs_20
    ];
    fakeRootCommands = ''
      mkdir -p etc tmp root home/nixuser
      echo "root:x:0:0:root:/root:/bin/bash" > etc/passwd
      echo "nixuser:x:0:0:root:/home/nixuser:/bin/bash" > etc/passwd
      echo "root:x:0:" > etc/group
      echo "nixbld:x:30000:nixuser" >> etc/group
    '';
    config = {
      Cmd = [ "${pkgs.bash}/bin/bash" ];
      Env = [
        "PATH=/usr/bin:/bin:/home/nixuser/.nix-profile/bin"
        "NIX_PAGER=cat"
        "USER=nixuser"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
    };
  };
in
{
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    docker-compose
    podman-compose
  ];

  # This systemd service ensures the image is loaded into Podman on boot
  systemd.services.load-custom-ci-image = {
    description = "Load custom CI image into podman";
    after = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];
    script = "${customCiImage} | ${pkgs.podman}/bin/podman load";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.highlights = {
      enable = true;
      name = "monolith";
      url = "https://codeberg.org/";
      tokenFile = config.age.secrets.forgejo.path;
      labels = [
        "nix-node:docker://forgejo-nix-node-runner:latest"

        "ubuntu-latest:docker://node:16-bullseye"
        "nixibert:docker://nixpkgs/nix"
        "nix:docker://nixos/nix"
        "cachix:docker://nixpkgs/cachix-flakes"
      ];
    };
  };
}
