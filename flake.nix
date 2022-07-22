{
  description = "Support for TrueType (.ttf) font files with Simple Directmedia Layer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    raqm_src.url = "github:HOST-Oman/libraqm/v0.7.2";
    raqm_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, raqm_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree rec {
          raqm = pkgs.stdenv.mkDerivation rec {
            pname = "libraqm";
            version = "0.7.2";
            src = raqm_src;
            nativeBuildInputs = [
              pkgs.meson
              pkgs.ninja
              pkgs.pkgconfig
              pkgs.python3
            ];
            buildInputs = [
              pkgs.freetype
              pkgs.harfbuzz
              pkgs.fribidi
            ];
            propagatedBuildInputs = [
              pkgs.glib
              pkgs.pcre
            ];
          };

          SDL2_ttf = pkgs.stdenv.mkDerivation {
            pname = "SDL2_ttf";
            version = "2.0.14-" + (if (self ? shortRev) then self.shortRev else "dirty");
            src = nixpkgs.lib.cleanSource ./.;
            cmakeFlags = [ "-DWITH_RAQM=1" ];
            nativeBuildInputs = [
              pkgs.cmake
              pkgs.pkg-config
            ];
            buildInputs = [
              raqm

              pkgs.SDL2
              pkgs.freetype
              pkgs.libGL
            ];
          };
          default = SDL2_ttf;
        };
      }
    );
}
