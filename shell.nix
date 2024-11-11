
with import <nixpkgs> { };
mkShell {
  buildInputs = [
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    glib
    gobject-introspection
    gobject-introspection.dev
    gtk3
    harfbuzz
    librsvg
    libsoup_3
    pango
    webkitgtk_4_1
    cargo
    pkg-config
    webkitgtk_4_1.dev
    openssl
    nodejs
  ];

  PKG_CONFIG_PATH = "${glib.dev}/lib/pkgconfig:${libsoup_3.dev}/lib/pkgconfig:${webkitgtk_4_1.dev}/lib/pkgconfig:${at-spi2-atk.dev}/lib/pkgconfig:${gtk3.dev}/lib/pkgconfig:${gdk-pixbuf.dev}/lib/pkgconfig:${cairo.dev}/lib/pkgconfig:${pango.dev}/lib/pkgconfig:${harfbuzz.dev}/lib/pkgconfig";
}
