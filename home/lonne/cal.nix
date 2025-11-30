{ config, pkgs, ... }:
{
  accounts.calendar = {
    basePath = ".local/share/calendar";
    accounts = {
      "lnbhn" = {
        primary = true;
        primaryCollection = "🐝🪹";
        remote = {
          type = "caldav";
          url = "https://cal.lnbhn.xyz/";
          userName = "leon";
          passwordCommand = ["${pkgs.coreutils}/bin/cat" config.age.secrets.radicale.path];
        };
        vdirsyncer = {
          enable = true;
        };
        khal = {
          enable = true;
          type = "discover";
        };
      };
    };
  };
}
