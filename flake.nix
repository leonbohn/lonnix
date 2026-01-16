{
  description = "Lonnix Managed Config";

  inputs = {
    # Nixpkgs - Using 24.11 (current stable) or nixos-unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix2container.url = "github:nlewo/nix2container";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      nix-index-database,
      nix2container,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      user = "lonne";
      pref = "lonnix";

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Helper for treefmt
      treefmtEval = forAllSystems (
        system:
        inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
          };
        }
      );

      # Helper function for NixOS configurations
      mkNixos =
        nick: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              outputs
              nick
              user
              pref
              ;

            nix2container = nix2container.packages.${system}.nix2container;

            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };

            sopsrets = ./secrets.yaml;
          };
          modules = [
            {
              nixpkgs.hostPlatform = system;

              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.android_sdk.accept_license = true;

            }
            ./host/common
            ./host/${nick}

            nix-index-database.nixosModules.default

            {
              programs.nix-index-database.comma.enable = true;
            }

            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  nick
                  user
                  pref
                  ;
              };

              home-manager.users.${user} = {
                imports = [
                  ./home/${user}
                  inputs.sops-nix.homeManagerModules.sops
                ];
              };
            }
            # Add hardware-specific tweaks for the Pi
            (if nick == "pi" then nixos-hardware.nixosModules.raspberry-pi-4 else { })
          ];
        };
    in
    {
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      nixosConfigurations = {
        "${pref}-pc" = mkNixos "pc" "x86_64-linux";
        "${pref}-pi" = mkNixos "pi" "aarch64-linux";
      };

      # homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      #   modules = [ ];
      # };
    };
}
