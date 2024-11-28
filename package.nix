{ lib
, stdenv
, rustPlatform
, nodejs
, pnpm_9
, wrapGAppsHook3
, cargo
, rustc
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
  version = "v2.0.0";
  
  src = ./build/.;  # Use current directory as source
  
  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  cargoDeps = rustPlatform.importCargoLock { 
    lockFile = ./bowos-settings/src-tauri/Cargo.lock;  # Adjust path based on your directory structure
  };

  pnpmRoot = "..";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
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



  preConfigure = ''
    # Make parent directory writable for pnpm.configHook
  '';

  meta = with lib; {
    description = "Settings app for BowOS.";
    mainProgram = "bowos-settings";
    homepage = "https://bowos-settings.example.com";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.your-maintainer ];
  };
}