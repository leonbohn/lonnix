{
  sopsrets,
  user,
  ...
}:
{
  sops = {
    defaultSopsFile = sopsrets;

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "forgejo" = { };

      "paperless_admin_password" = {
        # owner = config.users.users.paperless.name;
      };

      "atuinkey" = {
        owner = user;
      };
      "atuinsession" = {
        owner = user;
      };
      "rwth_tim_password" = {
        owner = user;
      };
      "gmail_password" = {
        owner = user;
      };
    };
  };
}
