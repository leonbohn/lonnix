{
  pkgs,
  config,
  ...
}:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "lonne" ];
    };
  };

  users.users."lonne".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1TaMkt0sCGquHbdLyGTTG4jo5f+A0ShWbxgNULoL5T lonne"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI lonne"
  ];
}
