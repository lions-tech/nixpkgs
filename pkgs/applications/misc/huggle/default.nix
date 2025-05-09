{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  which,
  cmake,
  wrapQtAppsHook,
  qtwebengine,
  yaml-cpp,
  libirc,
}:

stdenv.mkDerivation rec {
  pname = "huggle";
  version = "3.4.13";

  src = fetchFromGitHub {
    owner = "huggle";
    repo = "huggle3-qt-lx";
    tag = version;
    sha256 = "sha256-f7Oo6x262Ju9KY8f/xjm9gL6I1fRCaDsQWGWJMUNUfY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    which
    cmake
  ];
  buildInputs = [
    ncurses
    yaml-cpp
    qtwebengine
    libirc
  ];

  patches = [
    ./00-remove-third-party.patch
    ./01-extensions.patch
  ];
  postPatch = ''
    rm -r src/3rd
    echo ${version} > src/huggle_core/version.txt
    substituteInPlace src/huggle_core/definitions_prod.hpp --subst-var out
    substituteInPlace src/CMakeLists.txt --replace '@libirc_includes@' '${libirc.out}'
  '';

  cmakeBuildType = "None";

  cmakeFlags = [
    "-S"
    "/build/source/src"
    "-DINSTALL_DATA_DIR=bin"
    "-DQT5_BUILD=ON"
    "-DWEB_ENGINE=ON"
    "-DBUILD_SHARED_LIBS=OFF"
    "-Wno-dev"
    "-DHUGGLE_EXT=TRUE"
  ];

  installTargets = [ "install" ];

  meta = with lib; {
    description = "Anti-vandalism tool for use on MediaWiki-based projects";
    mainProgram = "huggle";
    homepage = "https://github.com/huggle/huggle3-qt-lx";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.fee1-dead ];
    platforms = platforms.x86_64;
  };
}
