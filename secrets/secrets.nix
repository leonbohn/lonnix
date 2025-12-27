let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKn2DI6pDb3h4VFtnvXcb0fRbhK6SjcrVGFRQ0sWzEUR";
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
