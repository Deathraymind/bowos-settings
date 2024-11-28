{ pkgs ? import <nixpkgs> { } }:

let
  rustPlatform = pkgs.rustPlatform;
  lib = pkgs.lib;
in
rustPlatform.buildRustPackage rec {
  pname = "bowos-settings";
  version = "v2.0.2";

  # Point to the directory containing Cargo.toml and Cargo.lock

  src = ./.;



  # Use a placeholder for cargoSha256
  cargoSha256 = "sha256-mAD0yQNb49edyZjnelndOES5Ek+FgxpNnjMPzXWIY7c=";

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