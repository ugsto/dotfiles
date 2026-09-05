{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

let
  version = "0.8.3";

  sources = {
    x86_64-linux = {
      url = "https://github.com/AprilNEA/OpenLogi/releases/download/v${version}/openlogi-v${version}-linux-amd64.deb";
      hash = "sha256-uGJdIDQ0Uyfzr8rRma37q2O+8ppjDpBiMvlyPEc2KRI=";
    };
    aarch64-linux = {
      url = "https://github.com/AprilNEA/OpenLogi/releases/download/v${version}/openlogi-v${version}-linux-arm64.deb";
      hash = "sha256-ScCCp5EdY2BEk/2GoGIVIm36HR5OXjoCt0XmHvg16rY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "openlogi";
  inherit version;

  src = fetchurl {
    url =
      sources.${stdenv.hostPlatform.system}.url
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    hash = sources.${stdenv.hostPlatform.system}.hash;
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    libxcb
    libxkbcommon
    stdenv.cc.cc.lib
  ];

  # GPUI discovers its graphics backends and font stack with dlopen instead of
  # linking them, so autoPatchelf cannot infer these from the ELF headers.
  appendRunpaths = map (pkg: "${lib.getLib pkg}/lib") [
    fontconfig
    freetype
    libGL
    vulkan-loader
    wayland
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    for binary in openlogi openlogi-agent openlogi-desktop openlogi-overlay; do
      install -Dm755 "usr/bin/$binary" "$out/bin/$binary"
    done

    install -Dm644 usr/share/applications/openlogi.desktop \
      "$out/share/applications/openlogi.desktop"
    cp -r usr/share/icons "$out/share/icons"
    cp -r usr/share/licenses "$out/share/licenses"

    install -Dm644 etc/udev/rules.d/70-openlogi.rules \
      "$out/lib/udev/rules.d/70-openlogi.rules"
    install -Dm644 usr/lib/systemd/user/openlogi-agent.service \
      "$out/share/systemd/user/openlogi-agent.service"

    substituteInPlace "$out/share/systemd/user/openlogi-agent.service" \
      --replace-fail \
        "ExecStart=/usr/bin/openlogi-agent" \
        "ExecStart=$out/bin/openlogi-agent"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Local-first alternative to Logitech Options+ for HID++ peripherals";
    homepage = "https://github.com/AprilNEA/OpenLogi";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "openlogi";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
