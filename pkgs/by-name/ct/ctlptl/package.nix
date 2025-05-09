{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.40";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-O6oAkYzkBUecwAcLjPIR7D/k4REWND8TWdstPNVJ0MU=";
  };

  vendorHash = "sha256-1BrohvN3Eefuy2y7pjdwhzFQG9YLr9X/CLbOeTBZkjY=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/ctlptl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd ctlptl \
      --bash <($out/bin/ctlptl completion bash) \
      --fish <($out/bin/ctlptl completion fish) \
      --zsh <($out/bin/ctlptl completion zsh)
  '';

  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
