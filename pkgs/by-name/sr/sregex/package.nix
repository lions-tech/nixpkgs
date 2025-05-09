{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "sregex";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "sregex";
    tag = "v${version}";
    hash = "sha256-HZ9O/3BQHHrTVLLlU0o1fLHxyRSesBhreT3IdGHnNsg=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "CC:=$(CC)"
  ];

  meta = with lib; {
    homepage = "https://github.com/openresty/sregex";
    description = "Non-backtracking NFA/DFA-based Perl-compatible regex engine matching on large data streams";
    mainProgram = "sregex-cli";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
