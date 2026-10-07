{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.10.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/argoproj-labs/argocd-agent/releases/download/v${version}/argocd-agentctl-linux-amd64";
      hash = "sha256-/VJ0UKLoy/VE8zTWfrY9g6STyhkYK1BanMsMpqGg7hs=";
    };
    aarch64-linux = {
      url = "https://github.com/argoproj-labs/argocd-agent/releases/download/v${version}/argocd-agentctl-linux-arm64";
      hash = "sha256-Fk95Vk9BtZ54j/uj5u+hwNmC/vxj7kG3T4w3q+mFPok=";
    };
  };
in
stdenv.mkDerivation {
  pname = "argocd-agentctl";
  inherit version;

  src = fetchurl {
    url =
      sources.${stdenv.hostPlatform.system}.url
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    hash = sources.${stdenv.hostPlatform.system}.hash;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/argocd-agentctl
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI for managing Argo CD Agent";
    homepage = "https://github.com/argoproj-labs/argocd-agent";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "argocd-agentctl";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
