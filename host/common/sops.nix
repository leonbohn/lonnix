{ config, sopsrets, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets.yaml;

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "paperless_admin_password" = {
        # owner = config.users.users.paperless.name;
      };
    };
  };
}
