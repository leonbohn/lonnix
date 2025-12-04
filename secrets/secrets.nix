let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlZVkiOvQE4wCLXmuYfvbJVZFyqIjqI8Aa+/EBUqiI";
  pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKIqkUvghzdJab2YsPmLV3ZGwUnSl01Or+9zKgf4jdPc";
in
{
  "mail.age".publicKeys = [
    pc
    pi
  ];
  "radicale.age".publicKeys = [ pc ];
  "sciebo.age".publicKeys = [ pc ];
}
