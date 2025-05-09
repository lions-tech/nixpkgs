{
  mkDerivation,
  lib,
  fetchFromGitHub,
  tinyxml-2,
  cmake,
  qtbase,
  qtmultimedia,
}:
mkDerivation rec {
  version = "1.0.13";
  pname = "pro-office-calculator";

  src = fetchFromGitHub {
    owner = "RobJinman";
    repo = "pro_office_calc";
    tag = "v${version}";
    sha256 = "1v75cysargmp4fk7px5zgib1p6h5ya4w39rndbzk614fcnv0iipd";
  };

  buildInputs = [
    qtbase
    qtmultimedia
    tinyxml-2
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Completely normal office calculator";
    mainProgram = "procalc";
    homepage = "https://proofficecalculator.com/";
    maintainers = [ maintainers.pmiddend ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
