{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  click,
  colorama,
  intelhex,
  packaging,
  pyaml,
  pyftdi,
  pyserial,
  requests,
  schema,
}:
buildPythonPackage rec {
  pname = "bcf";
  version = "1.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-firmware-tool";
    tag = "v${version}";
    sha256 = "i28VewTB2XEZSfk0UeCuwB7Z2wz4qPBhzvxJIYkKwJ4=";
  };

  postPatch = ''
    sed -ri 's/@@VERSION@@/${version}/g' \
      bcf/__init__.py setup.py
  '';

  propagatedBuildInputs = [
    appdirs
    click
    colorama
    intelhex
    packaging
    pyaml
    pyftdi
    pyserial
    requests
    schema
  ];

  pythonImportsCheck = [ "bcf" ];
  doCheck = false; # Project provides no tests

  meta = with lib; {
    homepage = "https://github.com/hardwario/bch-firmware-tool";
    description = "HARDWARIO Firmware Tool";
    mainProgram = "bcf";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
