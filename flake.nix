{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      # url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-index-database,
      agenix,
      treefmt-nix,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      treefmtEval = forAllSystems (
        system:
        treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true; # Format Nix files
            prettier.enable = true; # Format JSON, YAML, Markdown
            shellcheck.enable = true; # Lint shell scripts
            shfmt.enable = true; # Format shell scripts
          };
          settings.formatter = {
            prettier.excludes = [ "*.lock" ];
          };
        }
      );
    in
    {
      # Formatter for `nix fmt`
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      # Checks for `nix flake check`
      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });

      nixosConfigurations = {
        "lonnix-pc" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            # secrets = ./secrets;
          };
          modules = [
            ./host/common
            ./host/pc

            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
                secrets = ./secrets;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lonne = import ./home/lonne;
            }
          ];
        };
        "lonnix-pi" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            # secrets = ./secrets;
          };
          modules = [
            ./host/common
            ./host/pi

            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lonne = import ./home/lonne;
            }
          ];
        };
      };
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "lonne@lonnix-pc" = home-manager.lib.homeManagerConfiguration {
          # inherit pkgs;
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit self inputs;
            res = ./secrets;
          };
          modules = [
            agenix.homeManagerModules.default

            ./home/default.nix
          ];
        };
      };
    };
}
