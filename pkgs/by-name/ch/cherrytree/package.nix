{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  wrapGAppsHook3,
  gtkmm3,
  gtksourceview4,
  gtksourceviewmm,
  gspell,
  libxmlxx,
  sqlite,
  curl,
  libuchardet,
  spdlog,
  fribidi,
  vte,
  icu,
  libepoxy,
  lerc,
  libdatrie,
  libthai,
  pcre2,
  libsysprof-capture,
  librsvg,
  libXdmcp,
  imagemagick,
  libicns,
  python3Packages,
}:

let
  plistMinimal =
    { app-name, version }:
    ''
      <?xml version="1.0" encoding="UTF-8" standalone="no"?><plist version="1.0">
        <dict>
          <key>CFBundleExecutable</key>
          <string>${app-name}</string>
          <key>CFBundleGetInfoString</key>
          <string>${app-name} ${version}</string>
          <key>CFBundleVersion</key>
          <string>${version}</string>
          <key>CFBundleShortVersionString</key>
          <string>${version}</string>
          <key>CFBundleIconFile</key>
          <string>Icon.icns</string>
          <key>CFBundleIconName</key>
          <string>Icon.icns</string>
      </dict>
      </plist>
    '';

  macOsBundleScript =
    {
      bin-name,
      app-name,
      version,
      svg-path,
    }:
    ''
      set -e
      svg2icns() {
        local sizes="
            16,16x16
            32,32x32
            128,128x128
            256,256x256
            512,512x512
        "

        local base
        local iconset
        for SVG in "$@"; do
          base=$(basename "$SVG")
          base="''${base%.*}"
          iconset="$base.iconset"
          mkdir -p "$iconset"
          for PARAMS in $sizes; do
            ${lib.getBin imagemagick}/bin/magick $SVG \
              -resize "''${PARAMS%,*}" "$iconset/icon_''${PARAMS#*,}.png"
          done

          ${lib.getBin libicns}/bin/png2icns Icon.icns "$iconset"/*.png
        done
      }

      mkdir -p $out/Applications/${app-name}.app/Contents/MacOS
      ln -s "$out/bin/${bin-name}" "$out/Applications/${app-name}.app/Contents/MacOS/${app-name}"
      echo "${
        plistMinimal { inherit app-name version; }
      }" > "$out/Applications/${app-name}.app/Contents/Info.plist"
      svg2icns ${svg-path}
      mkdir -p $out/Applications/${app-name}.app/Contents/Resources
      mv *.icns $out/Applications/${app-name}.app/Contents/Resources/Icon.icns
    '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "cherrytree";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "giuspen";
    repo = "cherrytree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X87L3oSidnXH/IIHtVbeIn0ehWkSgrAkX0+TUGQomV0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs =
    [
      gtkmm3
      gtksourceview4
      gtksourceviewmm
      gspell
      libxmlxx
      sqlite
      curl
      libuchardet
      spdlog
      fribidi
      vte
      icu
      libepoxy
      lerc
      libdatrie
      libthai
      pcre2
      libsysprof-capture
      librsvg
      libXdmcp
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      python3Packages.pyobjc-core
      python3Packages.pyobjc-framework-Cocoa
    ];

  meta = {
    description = "Hierarchical note taking application";
    mainProgram = "cherrytree";
    longDescription = ''
      Cherrytree is an hierarchical note taking application, featuring rich
      text, syntax highlighting and powerful search capabilities. It organizes
      all information in units called "nodes", as in a tree, and can be very
      useful to store any piece of information, from tables and links to
      pictures and even entire documents. All those little bits of information
      you have scattered around your hard drive can be conveniently placed into
      a Cherrytree document where you can easily find it.
    '';
    homepage = "https://www.giuspen.com/cherrytree";
    changelog = "https://raw.githubusercontent.com/giuspen/cherrytree/${finalAttrs.version}/changelog.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.lionstech ];
    platforms = lib.platforms.unix;
  };
})
