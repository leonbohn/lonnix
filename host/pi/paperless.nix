{ config, pkgs, ... }:
{
  sops.secrets."paperless_admin_password" = {
    owner = config.users.users.paperless.name;
  };

  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."paperless_admin_password".path;

    settings = {
      PAPERLESS_ADMIN_USER = "lonne";
      PAPERLESS_URL = "http://192.168.178.71";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";

      PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [
        ".DS_STORE/*"
        "desktop.ini"
      ];

      PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
