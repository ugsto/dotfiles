{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

let
  version = "0.64.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/MagaluCloud/mgccli/releases/download/v${version}/mgccli_${version}_linux_amd64.tar.gz";
      hash = "sha256-y+6orIP28eAPv7/P5D9AXQWwvVpP8evpNXDRU6AQtiM=";
    };
    aarch64-linux = {
      url = "https://github.com/MagaluCloud/mgccli/releases/download/v${version}/mgccli_${version}_linux_arm64.tar.gz";
      hash = "sha256-/Q6/1aY3DM1aMLhgq5dRAvAsQYQCcBScYF2LXrUiihI=";
    };
    x86_64-darwin = {
      url = "https://github.com/MagaluCloud/mgccli/releases/download/v${version}/mgccli_${version}_darwin_amd64.tar.gz";
      hash = "sha256-V+IHDP3cs41XGQZgukqVbSbU1hxZa/DKIBlzO9QiH68=";
    };
    aarch64-darwin = {
      url = "https://github.com/MagaluCloud/mgccli/releases/download/v${version}/mgccli_${version}_darwin_arm64.tar.gz";
      hash = "sha256-77cZo8/30uBI/Gd443sO8VFbPCZbHWaesitpinHPByc=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "mgccli";
  inherit version;

  src = fetchurl {
    url =
      sources.${stdenv.hostPlatform.system}.url
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    hash = sources.${stdenv.hostPlatform.system}.hash;
  };

  nativeBuildInputs = [ installShellFiles ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 mgc $out/bin/mgc
    ln -s $out/bin/mgc $out/bin/mgccli

    installShellCompletion --cmd mgc \
      --bash <($out/bin/mgc completion bash) \
      --zsh <($out/bin/mgc completion zsh) \
      --fish <($out/bin/mgc completion fish)

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official Command Line Interface for Magalu Cloud (MGC)";
    homepage = "https://github.com/MagaluCloud/mgccli";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "mgc";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
