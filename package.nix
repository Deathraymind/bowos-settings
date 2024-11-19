{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, nodejs
, pnpm_9
, wrapGAppsHook3
, cargo
, rustc
, cargo-tauri
, pkg-config
, esbuild
, buildGoModule
, libayatana-appindicator
, gtk3
, webkitgtk_4_1
, libsoup
, openssl
, xdotool
}:

let
  pnpm = pnpm_9;
in
stdenv.mkDerivation rec {
  pname = "bowos-settings";
  version = "2.0.0"; # Update to match your app's version

  src = fetchFromGitHub {
    owner = "your-org";
    repo = "bowos-settings";
    rev = "v${version}";
    hash = "sha256-..."; # Replace with the actual hash
  };

  sourceRoot = "${src}/src-tauri";

  postPatch = ''
    # Patch for libayatana-appindicator
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  # Frontend dependencies using pnpm
  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-..."; # Replace with the correct hash of node_modules
  };

  pnpmRoot = ".."; # Adjust path as needed

  # Rust dependencies using Cargo.lock
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./bowos-settings/src-tauri/Cargo.lock;
    outputHashes = {
      # Replace with actual hashes for your dependencies
      "tauri-plugin-v2-0.0.0" = "sha256-..."; # Example placeholder
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri.hook # Adjusted for Tauri v2
    nodejs
    pnpm.configHook
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    gtk3
    libsoup
    libayatana-appindicator
    openssl
    webkitgtk_4_1
    xdotool
  ];

  env.ESBUILD_BINARY_PATH = "${lib.getExe (
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args // rec {
            version = "0.21.5";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
            };
          }
        );
    }
  )}";

  # Pre-configure step for frontend build
  preConfigure = ''
    chmod +w ..
    pnpm install
    pnpm run build
  '';

  # Meta information
  meta = {
    description = "Settings app for BowOS.";
    mainProgram = "bowos-settings";
    homepage = "https://bowos-settings.example.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ your-maintainer ];
  };
}
