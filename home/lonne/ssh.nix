{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "vps" = {
        hostname = "152.53.1.124";
        user = "leon";
        identityFile = "~/.ssh/vps";
        setEnv = {
          TERM = "xterm-256color";
        };
      };

      "pi" = {
        hostname = "192.168.178.71";
        user = "lonne";
        identityFile = "~/.ssh/pi";
      };
    };
  };
}
