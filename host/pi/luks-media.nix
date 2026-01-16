{ config, ... }:
{
  boot.initrd.luks.devices."decrypted_media" = {
    device = "/dev/disk/by-uuid/dc69f11c-a9e0-4b76-8207-61fefcfbdb62";

    keyFile = config.sops.secrets."luks_media_password".path;
  };

  fileSystems."/media" = {
    device = "/dev/mapper/decrypted_media";
    fsType = "ext4";
    neededForBoot = false;
  };
}
