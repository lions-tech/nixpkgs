{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  avogadrolibs,
  molequeue,
  hdf5,
  openbabel,
  qttools,
  wrapQtAppsHook,
  mesa,
}:

let
  avogadroI18N = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadro-i18n";
    rev = "7eef0b83ded6221a3ddb85c0118cc26f9a35375c";
    hash = "sha256-AR/y70zeYR9xBzWDB5JXjJdDM+NLOX6yxCQte2lYN/U=";
  };

in
stdenv.mkDerivation rec {
  pname = "avogadro2";
  version = "1.100.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    tag = version;
    hash = "sha256-NSozi6oElNTIFTdRW32ZcNm8Ae311xk6kN1wtrEqjaU=";
  };

  postUnpack = ''
    cp -r ${avogadroI18N} avogadro-i18n
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    avogadrolibs
    molequeue
    eigen
    hdf5
    qttools
  ];

  propagatedBuildInputs = [ openbabel ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.getBin openbabel}/bin" ];

  meta = with lib; {
    description = "Molecule editor and visualizer";
    mainProgram = "avogadro2";
    maintainers = with maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadroapp";
    inherit (mesa.meta) platforms;
    license = licenses.bsd3;
  };
}
