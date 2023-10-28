{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec
    {

      packages = rec {

        frag = pkgs.nim2Packages.buildNimPackage {
          pname = "frag";
          version = "0.1.0";
          nimBinOnly = true;
          nimRelease = false;
          src = ./.;
        };

        default = frag;
      };

      apps.default = {
        type = "app";
        program = "${packages.frag}/bin/frag";
      };

      devShells.default = with pkgs; mkShell {
        packages = [
          nim2
        ];
      };
    });
}