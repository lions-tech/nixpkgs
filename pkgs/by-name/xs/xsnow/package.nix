{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  wrapGAppsHook3,
  gtk3-x11,
  xorg,
  libxkbcommon,
  gsl,
}:
stdenv.mkDerivation rec {
  pname = "xsnow";
  version = "3.8.4";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${version}.tar.gz";
    sha256 = "sha256-ixfX/EGdwMOYu6nzcRUp7gjii0+T14CcqHCHIWmR2f8=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs =
    [
      gtk3-x11
      libxkbcommon
      libxml2
      gsl
    ]
    ++ (with xorg; [
      libX11
      libXpm
      libXt
      libXtst
    ]);

  makeFlags = [ "gamesdir=$(out)/bin" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "X-windows application that will let it snow on the root, in between and on windows";
    mainProgram = "xsnow";
    homepage = "https://ratrabbit.nl/ratrabbit/xsnow/";
    changelog = "https://ratrabbit.nl/ratrabbit/xsnow/changelog/index.html";
    downloadPage = "https://ratrabbit.nl/ratrabbit/xsnow/downloads/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      robberer
      griffi-gh
    ];
    platforms = platforms.unix;
  };
}
