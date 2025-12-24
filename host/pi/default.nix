{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "lonnix-pi";

  # Networkd setup
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "end0";
    address = [ "192.168.178.71/24" ];
    routes = [{ Gateway = "192.168.178.1"; }];
  };

  networking = {
    useNetworkd = true;
    dhcpcd.enable = false;
    defaultGateway = {
      address = "192.168.178.1";
      interface = "end0";
    };
    nameservers = [ "192.168.178.1" ];
  };

  environment.systemPackages = with pkgs; [ rustc cargo cargo-binstall ];

  system.stateVersion = "25.11";
}
