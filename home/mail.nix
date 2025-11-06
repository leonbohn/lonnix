{ pkgs, config, lib, ... }:
{
  accounts.email.accounts = {
    "rwth" = {
      address = "leon.bohn@rwth-aachen.de";
      realName = "León Bohn";
      thunderbird.enable = true;
      imap.host = "mail.rwth-aachen.de";
      msmtp.enable = true;
      smtp.host = "mail.rwth-aachen.de";
    };
    "lics" = {
      primary = true;
      address = "bohn@lics.rwth-aachen.de";
      realName = "León Bohn";
      thunderbird.enable = true;
      imap.host = "mail.rwth-aachen.de";
      msmtp.enable = true;
      smtp.host = "mail.rwth-aachen.de";
    };
  };
}
