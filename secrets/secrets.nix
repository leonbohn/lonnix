let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQCh+1cVgaPJzQCIGHT5DuOt6rZ6EfSV55wtHSuT36u";
in
{
  "mail.age".publicKeys = [
    pc
    pi
  ];
  "atuinkey.age".publicKeys = [
    pc
    pi
  ];
  "atuinsession.age".publicKeys = [
    pc
    pi
  ];
  "forgejo.age".publicKeys = [
    pc
    pi
  ];
}
