{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      fish
      tmux
      jq

      eza
      bottom
      lazygit
      git
      wget
      ripgrep
      curl

      clang
      rustc
      cargo
      cargo-binstall

    ] ++ [ inputs.agenix.packages.x86_64-linux.default ];
}
