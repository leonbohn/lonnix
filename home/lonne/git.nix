{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "León Bohn";
        email = "bohn@lics.rwth-aachen.de";
      };
      init.defaultBranch = "main";
      lfs.enable = true;
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

}
