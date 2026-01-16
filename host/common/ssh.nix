{
  user,
  ...
}:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "${user}" ];
    };
  };

  users.users.${user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1TaMkt0sCGquHbdLyGTTG4jo5f+A0ShWbxgNULoL5T ${user}"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI ${user}"
  ];
}
