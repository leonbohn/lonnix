{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      fish
      tmux

      eza
      bottom
      helix
      lazygit
      git
      wget
      ripgrep
      curl

      rustc
      cargo
      cargo-binstall

    ] ++ [ inputs.agenix.packages.x86_64-linux.default ];
}
