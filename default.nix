{ pkgs ? import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  sha256 = "0sr45csfh2ff8w7jpnkkgl22aa89sza4jlhs6wq0368dpmklsl8g";
}) {} }:


let
  rustPlatform = pkgs.rustPlatform;
  lib = pkgs.lib;
in
rustPlatform.buildRustPackage rec {
  pname = "bowos-settings";
  version = "v2.0.0";

  # Point to the directory containing Cargo.toml and Cargo.lock

  src = fetchFromGitHub {
    owner = "deathraymind";
    repo = "bowos-settings";
    rev = version;
    hash = "";
    fetchSubmodules = true;
  };
  

  # Use a placeholder for cargoSha256
  cargoSha256 = "1MtDUhSQXCI8VDBLfckxLqoIuK9b6wu+HkaHwRGCbZk=";  

  # Native build inputs
  nativeBuildInputs = [
    pkgs.nodejs
    pkgs.pnpm
    pkgs.wrapGAppsHook
    pkgs.pkg-config
    pkgs.esbuild 
  ];

  # Runtime dependencies
  buildInputs = [
    pkgs.gtk3
    pkgs.libsoup
    pkgs.openssl
    pkgs.xdotool
    pkgs.libayatana-appindicator
    pkgs.webkitgtk_4_1.dev 
  ];
}
