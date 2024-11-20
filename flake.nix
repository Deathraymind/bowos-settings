{
  description = "Flake for bowos-settings development environment";

  inputs = {
    # Fetch Nixpkgs unstable for the latest packages
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    
    lib = pkgs.lib;
  in
  {
    # Define the package
    packages.${system}.bowos-settings = pkgs.rustPlatform.buildRustPackage rec {
      pname = "bowos-settings";
      version = "v2.0.0";

      src = ./bowos-settings/src-tauri;

      cargoSha256 = "1MtDUhSQXCI8VDBLfckxLqoIuK9b6wu+HkaHwRGCbZk=";  

      nativeBuildInputs = [
        pkgs.nodejs
        pkgs.pnpm
        pkgs.wrapGAppsHook
        pkgs.pkg-config
        pkgs.esbuild 
      ];

      buildInputs = [
        pkgs.gtk3
        pkgs.libsoup
        pkgs.openssl
        pkgs.xdotool
        pkgs.libayatana-appindicator
        pkgs.webkitgtk_4_1.dev 
      ];
    };

    # Define the development shell
    devShell.${system} = pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.nodejs
        pkgs.pnpm
        pkgs.wrapGAppsHook
        pkgs.pkg-config
        pkgs.esbuild
        pkgs.rustPlatform.rustc
        pkgs.rustPlatform.cargo
      ];

      buildInputs = [
        pkgs.gtk3
        pkgs.libsoup
        pkgs.openssl
        pkgs.xdotool
        pkgs.libayatana-appindicator
        pkgs.webkitgtk_4_1.dev
      ];

      # Environment variables (optional)
      shellHook = ''
        echo "Entering development environment for bowos-settings"
      '';
    };
  };
}
