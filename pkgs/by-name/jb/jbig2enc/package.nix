{
  lib,
  stdenv,
  fetchFromGitHub,
  leptonica,
  zlib,
  libwebp,
  giflib,
  libjpeg,
  libpng,
  libtiff,
  python3,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "jbig2enc";
  version = "0.30";

  src = fetchFromGitHub {
    owner = "agl";
    repo = "jbig2enc";
    tag = version;
    hash = "sha256-B19l2NdMq+wWKQ5f/y5aoPiBtQnn6sqpaIoyIq+ugTg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    leptonica
    zlib
    libwebp
    giflib
    libjpeg
    libpng
    libtiff
    python3
  ];

  # We don't want to install this Python 2 script
  #postInstall = ''
  #  rm "$out/bin/pdf.py"
  #'';

  # This is necessary, because the resulting library has
  # /tmp/nix-build-jbig2enc/src/.libs before /nix/store/jbig2enc/lib
  # in its rpath, which means that patchelf --shrink-rpath removes
  # the /nix/store one.  By cleaning up before fixup, we ensure that
  # the /tmp/nix-build-jbig2enc/src/.libs directory is gone.
  preFixup = ''
    make clean
  '';

  meta = {
    description = "Encoder for the JBIG2 image compression format";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    homepage = "https://github.com/agl/jbig2enc";
    mainProgram = "jbig2";
  };
}
