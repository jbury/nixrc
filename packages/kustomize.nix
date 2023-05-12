{ lib, buildGo119Module, fetchFromGitHub, installShellFiles }:

buildGo119Module rec {
  pname = "kustomize";
  version = "5.0.1";

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
    sha256 = "sha256-wVdB9fTLYg7Ma0dRgDt7X7ncN0+04DyT8kp2+/aQ018=";
  };

  GOWORK="off";

  # avoid finding test and development commands
  modRoot = "kustomize";

  vendorSha256 = "sha256-bY3TxRErkUEaBCSk0w7LhvLC10YDCJhPV73fKwlWuFI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kustomize \
      --bash <($out/bin/kustomize completion bash) \
      --fish <($out/bin/kustomize completion fish) \
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
