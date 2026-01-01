let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKn2DI6pDb3h4VFtnvXcb0fRbhK6SjcrVGFRQ0sWzEUR";
  both = [
    pi
    pc
  ];
in
{
  "mail.age".publicKeys = both;
  "atuinkey.age".publicKeys = both;
  "atuinsession.age".publicKeys = both;
  "forgejo.age".publicKeys = both;
}
