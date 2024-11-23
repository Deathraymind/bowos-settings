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
  version = "v2.0.4";

  git = pkgs.fetchFromGitHub {
    owner = "deathraymind";
    repo = "bowos-settings";
    rev = "v2.0.4";
    hash = "sha256-aJh7Okttcr+pn7XT7COipkqyc1DMhhffva9opolfLBk=";
    fetchSubmodules = true;
  };

  src = "${git}/bowos-settings/src-tauri/";

  # Use a placeholder for cargoSha256
  cargoSha256 = "sha256-Ui8g/X/NFHV2wNyC2jisnOw8PmMNnHoo3CGESzgMp+8=";

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

  installPhase = ''
    mkdir -p $out/bin
    cp "${git}/result/bin/bowos-settings" $out/bin/


   
  '';

  meta = with lib; {
    description = "BowOS Settings App";
    homepage = "https://github.com/deathraymind/bowos-settings";
    license = licenses.mit;
    maintainers = with maintainers; [ Deathraymind ];
  };
}
