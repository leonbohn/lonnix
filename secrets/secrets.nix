let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBupl0erUsCZSRwxaypJQX8OYf/MK9H29PGMUSXI5uq7";
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
