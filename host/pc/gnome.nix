{ config, pkgs, ... }:
{
  services.desktopManager.gnome.enable = true;
  services.desktopManager.cosmic.enable = true;

  environment.systemPackages = with pkgs; [
    flatpak
    gnome-software

    gnome-tweaks
    gnomeExtensions.home-assistant-extension
    gnomeExtensions.smart-home
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-panel
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.just-perfection
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.dbus.packages = [ pkgs.gcr ];

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "systemd-networkd.service" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
