{
  pkgs,
  user,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = user;
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
