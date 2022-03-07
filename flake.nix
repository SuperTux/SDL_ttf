{
  description = "Support for TrueType (.ttf) font files with Simple Directmedia Layer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree rec {
          raqm = pkgs.stdenv.mkDerivation rec {
            pname = "libraqm";
            version = "0.7.2";
            src = fetchTarball {
              url = "https://github.com/HOST-Oman/libraqm/releases/download/v${version}/raqm-${version}.tar.xz";
              sha256 = "1shcs5l27l7380dvacvhl8wrdq3lix0wnhzvfdh7vx2pkzjs3zk6";
            };
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
        };
        defaultPackage = packages.SDL2_ttf;
      });
}
