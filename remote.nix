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
  version = "v2.0.3";

  git = pkgs.fetchFromGitHub {
    owner = "deathraymind";
    repo = "bowos-settings";
    rev = "v2.0.3";
    hash = "sha256-hZY/XsIxRtSA/UBCrzTr+YqBfMBQ/JBQO5pCpVEPZYU=";
    fetchSubmodules = true;
  };

  src = "${git}/bowos-settings/src-tauri/";

  # Use a placeholder for cargoSha256
  cargoSha256 = "sha256-1Q11fWjpuklDO9EQxmJgrhD+It7ImDM2pbICY/CHi54=";

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
    
    # Create .desktop file
    mkdir -p $out/share/applications
    cat > $out/share/applications/bowos-settings.desktop <<EOF
    [Desktop Entry]
    Name=BowOS Settings
    Exec=$out/bin/bowos-settings
    Icon=$out/share/icons/bowos-settings.png
    Type=Application
    Categories=Utility;Settings;
    EOF


   
  '';

  meta = with lib; {
    description = "BowOS Settings App";
    homepage = "https://github.com/deathraymind/bowos-settings";
    license = licenses.mit;
    maintainers = with maintainers; [ Deathraymind ];
  };
}
