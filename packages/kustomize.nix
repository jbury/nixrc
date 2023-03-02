{ lib, buildGo119Module, fetchFromGitHub, installShellFiles }:

buildGo119Module rec {
  pname = "kustomize";
  version = "4.5.7";

  ldflags = let t = "sigs.k8s.io/kustomize/api/provenance"; in
    [
      "-s"
      "-X ${t}.version=${version}"
      "-X ${t}.gitCommit=${src.rev}"
    ];

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "kustomize/v${version}";
    sha256 = "sha256-AHDUwXcYkI04nOBY8jScf+OE6k9Z5OqzhtWExK1rrKg=";
  };

  GOWORK="off";

  # avoid finding test and development commands
  modRoot = "kustomize";

  vendorSha256 = "sha256-zx/s9dlBkUN3+j5Yz6DYChW6zLjcR26IknVs8Y9acPw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kustomize \
      --zsh <($out/bin/kustomize completion zsh)
  '';

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = "https://github.com/kubernetes-sigs/kustomize";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos vdemeester periklis zaninime Chili-Man saschagrunert ];
  };
}
