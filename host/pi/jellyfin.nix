{
  pkgs,
  config,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "lonne";
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
