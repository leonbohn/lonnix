{
  pkgs,
  config,
  nix2container,
  ...
}:

let
  nixosImage = nix2container.pullImage {
    imageName = "nixos/nix";
    imageDigest = "sha256:081b65e50a5c4e6ef4a9094a462da3b83ff76bfec70236eb010047fcee36e11c";
    arch = "amd64";
    sha256 = "sha256-UTiZD4EPpS0VNzTMOa2CQPrMsGk78NIsdiilsihdSBE=";
  };

  fnnr = nix2container.buildImage {
    # tag = "latest";
    name = "fnnr";
    fromImage = nixosImage;
    config = {
      Env = [
        "NIX_PAGER=cat"
        "USER=nobody"
        "HOME=/"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
    };

    copyToRoot = with pkgs; [
      coreutils
      openssh
      nix
      bash
      nodejs_22
      cacert
      git
      zola
    ];

    # ensure that nix command can be invoked
    initializeNixDatabase = true;

    layers = [
      (nix2container.buildLayer {
        deps = with pkgs; [
          coreutils
          openssh
          nix
          bash
          nodejs_22
          cacert
          git
          zola
        ];
      })
    ];
  };
in
{
  # This systemd service ensures the image is loaded into Podman on boot
  systemd.services.load-fnnr = {
    description = "Load custom CI image '${fnnr.imageName}' into podman";
    after = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];
    script = "${fnnr.copyToPodman}/bin/copy-to-podman";
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
      tokenFile = config.sops.secrets.forgejo.path;
      labels = [
        "fnnr:docker://library/${fnnr.imageName}:${fnnr.imageTag}"
        "nix:docker://nixos/nix"
      ];
    };
  };
}
