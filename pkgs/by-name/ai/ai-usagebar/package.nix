{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  procps,
  xdg-utils,
}:

let
  version = "1.10.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/akitaonrails/ai-usagebar/releases/download/v${version}/ai-usagebar-linux-x86_64.tar.gz";
      hash = "sha256-/6NU6WUCPEkicKE/wSYwT7ZiNw/52/dpl1EkFRHNSAQ=";
    };
    aarch64-linux = {
      url = "https://github.com/akitaonrails/ai-usagebar/releases/download/v${version}/ai-usagebar-linux-aarch64.tar.gz";
      hash = "sha256-i5JlsBEVJRT63yCCM3d2cnoh/ZH0fYdHRnmJ2eDIlkY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "ai-usagebar";
  inherit version;

  src = fetchurl {
    url =
      sources.${stdenv.hostPlatform.system}.url
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    hash = sources.${stdenv.hostPlatform.system}.hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 ai-usagebar "$out/bin/ai-usagebar"
    install -Dm755 ai-usagebar-tui "$out/bin/ai-usagebar-tui"

    install -Dm644 config.example.toml "$out/share/ai-usagebar/config.example.toml"
    install -Dm644 README.md "$out/share/doc/ai-usagebar/README.md"
    install -Dm644 LICENSE "$out/share/licenses/ai-usagebar/LICENSE"

    runHook postInstall
  '';

  # Matches the wrapping upstream's nix/package.nix applies on Linux: both
  # programs shell out to these at runtime.
  postFixup = ''
    for program in ai-usagebar ai-usagebar-tui; do
      wrapProgram "$out/bin/$program" \
        --prefix PATH : ${
          lib.makeBinPath [
            procps
            xdg-utils
          ]
        }
    done
  '';

  meta = with lib; {
    description = "Omarchy/Waybar widgets + TUI for tracking multi-provider AI plan usage";
    homepage = "https://github.com/akitaonrails/ai-usagebar";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "ai-usagebar";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
