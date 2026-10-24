# - Largely based on https://github.com/nolight132/photocraft-flake
# - will be obsolete with: https://github.com/Evolution0/bandcamp-dl/issues/227
{
  description = "Bandcamp-dl packaged as a nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.pyproject-nix = {
    url = "github:nix-community/pyproject.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      pyproject-nix,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        bandcamp-dl = pkgs.callPackage ./package.nix {
          inherit pyproject-nix;
        };
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.bandcamp-dl;
      });

      overlays.default = final: prev: {
        bandcamp-dl = final.callPackage ./package.nix {
          inherit pyproject-nix;
        };
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
