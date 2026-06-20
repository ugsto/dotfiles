{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2.54";

  sources = {
    x86_64-linux = {
      url = "https://x.ai/cli/grok-${version}-linux-x86_64";
      sha256 = "1yr7qfjd1zc8wbyzyfaf8iyzwarhqq97w1kfrb3amf2zan8nar2a"; # pragma: allowlist secret
    };
    aarch64-linux = {
      url = "https://x.ai/cli/grok-${version}-linux-aarch64";
      sha256 = "13zhi4zcnrj1x6pzsjx9v8lajspn5nl30aa26pjngqdk95cd65jq"; # pragma: allowlist secret
    };
  };
in
stdenv.mkDerivation {
  pname = "grok";
  inherit version;

  src = fetchurl {
    url =
      sources.${stdenv.hostPlatform.system}.url
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = sources.${stdenv.hostPlatform.system}.sha256;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/grok

    runHook postInstall
  '';

  meta = with lib; {
    description = "Grok CLI from x.ai";
    homepage = "https://x.ai/cli";
    license = licenses.unfree; # Assuming it's unfree as it's from x.ai
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "grok";
  };
}
