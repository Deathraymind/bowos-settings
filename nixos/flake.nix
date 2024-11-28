{
  inputs = {
    # Fetch the stable nixpkgs for your other dependencies
    nixpkgs.url = "nixpkgs";

    # Fetch the unstable nixpkgs for the latest rustc
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
    let
      # Use the stable nixpkgs for most dependencies
      pkgs = nixpkgs.legacyPackages.${system};

      # Use unstable nixpkgs for rustc
      unstablePkgs = nixpkgs-unstable.legacyPackages.${system};

      libraries = with pkgs; [ 
        webkitgtk 
        gtk3 
        cairo 
        gdk-pixbuf 
        glib 
        dbus 
        openssl_3_2 
        librsvg 
        webkitgtk_4_1.dev 
      ];

      nativeBuildInputs = with pkgs; [ 
        pkg-config 
        curl 
        wget 
        nodejs_20
        nodePackages.npm
        gcc 
        # Use unstable rustc from nixpkgs-unstable
        unstablePkgs.rustc 
        unstablePkgs.cargo 
      ];

      buildInputs = libraries ++ (with pkgs; [ 
        dbus 
        openssl_3_2 
        gtk3 
        libsoup 
        webkitgtk 
        librsvg 
      ]);

    in {
      devShell = pkgs.mkShell {
        inherit buildInputs nativeBuildInputs;
        
        shellHook = ''
          export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
        '';
      };

      packages.default = pkgs.rustPlatform.buildRustPackage {
        pname = "bowos-settings";
        version = "0.1.0";
        src = pkgs.lib.cleanSource ./bowos-settings/src-tauri;
        cargoLock = {
          lockFile = ./bowos-settings/src-tauri/Cargo.lock;
          allowBuiltinFetchGit = true;
        };

        inherit buildInputs nativeBuildInputs;

        LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

        postInstall = ''
          wrapProgram $out/bin/bowos-settings \
            --set LD_LIBRARY_PATH ${pkgs.lib.makeLibraryPath libraries}
        '';
      };
    }
  );
}