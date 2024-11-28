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
  version = "v2.0.5";

  src = pkgs.fetchFromGitHub {
    owner = "deathraymind";
    repo = "bowos-settings";
    rev = "v2.0.5";
    hash = "sha256-cJ1oVNebylVa+kfF2m/jqzvd0gbAfRJfK/l82j6SP+U=";
    fetchSubmodules = true;
  };

  # Use a placeholder for cargoSha256
  cargoSha256 = "sha256-xOrwVeFqGxE1ihHdJBvvExw4Ww6GqE0129t6uzc4Y4w=";

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


  meta = with lib; {
    description = "BowOS Settings App";
    homepage = "https://github.com/deathraymind/bowos-settings";
    license = licenses.mit;
    maintainers = with maintainers; [ Deathraymind ];
  };
}
