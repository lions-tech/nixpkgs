{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "ttylog";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "rocasa";
    repo = "ttylog";
    tag = version;
    sha256 = "0c746bpjpa77vsr88fxk8h1803p5np1di1mpjf4jy5bv5x3zwm07";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://ttylog.sourceforge.net";
    description = "Simple serial port logger";
    longDescription = ''
      A serial port logger which can be used to print everything to stdout
      that comes from a serial device.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "ttylog";
  };
}
