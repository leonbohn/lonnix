{ pkgs, config, lib, ... }: {
  accounts.email.accounts = {
    "lics" = {
      primary = true;
      address = "bohn@lics.rwth-aachen.de";
      realName = "León Bohn";

      thunderbird.enable = true;

      userName = "lb084651@lics.rwth-aachen.de";

      imap = {
        host = "mail.rwth-aachen.de";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "mail.rwth-aachen.de";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      # msmtp.enable = true;
    };
    "rwth" = {
      address = "leon.bohn@rwth-aachen.de";
      realName = "León Bohn";

      thunderbird.enable = true;

      userName = "lb084651@rwth-aachen.de";

      imap = {
        host = "mail.rwth-aachen.de";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "mail.rwth-aachen.de";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      # msmtp.enable = true;
    };

    "google" = {
      address = "leoboh241293@gmail.com";
      realName = "León Bohn";
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
      userName = "leoboh241293@gmail.com";
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls = { enable = true; };
      };
    };
  };
}
