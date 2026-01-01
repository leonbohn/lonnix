let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBT3EQ6VGTYbpnUTvI8h/tWG3Pklcp+ZU2sPXBR47hP";
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
