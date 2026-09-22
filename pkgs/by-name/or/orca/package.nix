{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,

  alsa-lib,
  at-spi2-core,
  atk,
  bash,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  git,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  vulkan-loader,
  wayland,
  xdg-utils,
}:

let
  version = "1.4.204";

  sources = {
    x86_64-linux = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-ide_${version}_amd64.deb";
      hash = "sha256-HTDe2UqoPSGM+LuzeHXp2JwTRgEMxTb8feH7aqwWYOw=";
    };
    aarch64-linux = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-ide_${version}_arm64.deb";
      hash = "sha256-6WZDIDLZvSVvJtT1cCeMNG+bWUctvws7unI7c58n54g=";
    };
  };

  # dlopen'ed by Electron at runtime, so autoPatchelf cannot infer them.
  runtimeLibs = [
    libGL
    pipewire
    systemd
    vulkan-loader
    wayland
  ];
in
stdenv.mkDerivation {
  pname = "orca";
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
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    stdenv.cc.cc.lib
  ];

  # wrapGAppsHook3 is here only for the GSettings schemas and pixbuf loaders; the
  # entry points are wrapped by hand below.
  dontWrapGApps = true;

  appendRunpaths = map (pkg: "${lib.getLib pkg}/lib") runtimeLibs;

  # The .deb carries a setuid chrome-sandbox; tar without -p drops the bit the
  # build sandbox is not permitted to set.
  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-owner --no-same-permissions
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r opt/Orca $out/lib/Orca

    install -Dm644 usr/share/applications/orca-ide.desktop \
      $out/share/applications/orca-ide.desktop
    substituteInPlace $out/share/applications/orca-ide.desktop \
      --replace-fail "Exec=/opt/Orca/orca-ide" "Exec=$out/lib/Orca/orca-ide"

    cp -r usr/share/icons $out/share/icons

    runHook postInstall
  '';

  # gappsWrapperArgs is only populated by wrapGAppsHook3 during fixup, so the
  # wrappers cannot be built in installPhase.
  #
  # The Electron binary is wrapped in place rather than via $out/bin because the
  # CLI script and `orca-ide open` exec it by its path next to resources/; a
  # wrapper elsewhere would leave those callers with an unwrapped environment.
  #
  # It serves double duty — Chromium for the GUI, plain Node under
  # ELECTRON_RUN_AS_NODE for the CLI — so the Wayland preference is passed as
  # ELECTRON_OZONE_PLATFORM_HINT (Electron 43) instead of --add-flags, which
  # would prepend Chromium switches to the CLI's argv as well.
  #
  # $out/bin/orca-ide is the CLI, matching upstream's own PATH entry: the relay
  # resolves the CLI on Linux as `orca-ide` to detect and launch agent teams.
  preFixup = ''
    wrapProgram $out/lib/Orca/orca-ide \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          xdg-utils
        ]
      } \
      --set-default ELECTRON_OZONE_PLATFORM_HINT auto

    makeWrapper $out/lib/Orca/resources/bin/orca-ide $out/bin/orca-ide \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          git
        ]
      }
  '';

  meta = with lib; {
    description = "Agentic development environment for running a fleet of parallel coding agents";
    homepage = "https://github.com/stablyai/orca";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "orca-ide";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
