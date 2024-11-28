{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libsoup_3,
  pango,
  webkitgtk_4_1,
  stdenv,
  darwin,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "bowos-settings";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "deathraymind";
    repo = "bowos-settings";
    rev = "v${version}";
    hash = "sha256-cJ1oVNebylVa+kfF2m/jqzvd0gbAfRJfK/l82j6SP+U=";
  };

  cargoHash = "sha256-PCUit/aMHwe7td7Nu5b/xHLCL0REDlZoo7w+q9vqp4M=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsoup_3
    pango
    webkitgtk_4_1
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
  ] ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  meta = {
    description = "";
    homepage = "https://github.com/deathraymind/bowos-settings";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "bowos-settings";
  };
}
