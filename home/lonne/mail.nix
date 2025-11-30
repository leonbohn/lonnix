{ pkgs, config, res, ... }: {
  accounts.email.accounts = let
    passwordCommand = account:
      "${pkgs.jq}/bin/jq -r .${account} ${config.age.secrets.mail.path}";
    refreshMinutes = 3;
  in {
    "lics@rwth" = {
      primary = true;
      address = "bohn@lics.rwth-aachen.de";
      realName = "León Bohn";

      thunderbird.enable = true;
      aerc = {
        enable = true;
        extraAccounts = {
          default = "INBOX";
          check-mail = "${builtins.toString refreshMinutes}m";
        };
      };

      userName = "lb084651@lics.rwth-aachen.de";
      passwordCommand = passwordCommand "rwth";

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
    };
    "studi@rwth" = {
      address = "leon.bohn@rwth-aachen.de";
      realName = "León Bohn";

      thunderbird.enable = true;
      aerc = {
        enable = true;
        extraAccounts = {
          default = "INBOX";
          check-mail = "${builtins.toString refreshMinutes}m";
        };
      };

      userName = "lb084651@rwth-aachen.de";
      passwordCommand = passwordCommand "rwth";

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

    "gmail" = {
      address = "leoboh241293@gmail.com";
      realName = "León Bohn";

      aerc = {
        enable = true;
        extraAccounts = {
          default = "INBOX";
          check-mail = "${builtins.toString refreshMinutes}m";
        };
      };
      thunderbird.enable = true;

      userName = "leoboh241293@gmail.com";
      passwordCommand = passwordCommand "gmail";
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
  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        unsafe-accounts-conf = true;
        default-saave-path = "~/Downloads";
      };

      ui = {
        dirlist-tree = true;
        message-list-split = "vertical 120";
      };

      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "text/html" = "html | colorize";
      };

      hooks = {
        mail-received = ''
          ${pkgs.libnotify}/bin/notify-send -a "aerc" "New Message from $AERC_FROM_NAME" \
          "[$AERC_ACCOUNT/$AERC_FOLDER] $AERC_SUBJECT"
        '';
        mail-sent = ''
          ${pkgs.libnotify}/bin/notify-send -a "aerc" "Message sent to $AERC_TO" \
          "[$AERC_ACCOUNT] $AERC_SUBJECT"
        '';
      };
    };

    extraBinds = {

      global = {
        "H" = ":prev-tab<Enter>";
        "L" = ":next-tab<Enter>";
        "?" = ":help keys<Enter>";
        "<C-[>" = "<Esc>";
      };

      messages = {
        "j" = ":next<Enter>";
        "J" = ":next 100%<Enter>";
        "k" = ":prev<Enter>";
        "K" = ":prev 100%<Enter>";

        "l" = ":next-folder<Enter>";
        "h" = ":prev-folder<Enter>";

        "/" = ":search<space>";
        "\\" = ":filter<space>";
        "n" = ":next-result<Enter>";
        "N" = ":prev-result<Enter>";
        "<Esc>" = ":clear<Enter>";

        "<Enter>" = ":view<Enter>";

        "mn" = ":compose<Enter>"; # compose new message
        "mr" = ":reply<Enter>"; # compose reply
        "mq" = ":reply -q<Enter>"; # compose reply with quote
        "ma" = ":reply -a<Enter>"; # compose reply all
        "mu" = ":reply -aq<Enter>"; # compose reply all with quote

        "<Space>" = ":mark -t<Enter>:next<Enter>";
        "q" = ":prompt 'Quit?' quit<Enter>";
      };

      "messages:folder=Drafts" = { "<Enter>" = ":recall<Enter>"; };

      view = {
        "<C-j>" = ":next<Enter>";
        "<C-k>" = ":prev<Enter>";
        "<C-l>" = ":next-part<Enter>";
        "<C-h>" = ":prev-part<Enter>";

        "q" = ":close<Enter>";
        "o" = ":open<Enter>";
        "s" = ":save<space>";
      };

      compose = {
        "<C-j>" = ":next-field<Enter>";
        "<C-k>" = ":prev-field<Enter>";
        "<tab>" = ":prev-field<Enter>";
        "<backtab>" = ":next-field<Enter>";
      };
    };
  };
}
