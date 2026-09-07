{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  patchelf,

  # Runtime dependencies
  alsa-lib,
  at-spi2-core,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  vulkan-loader,
  wayland,
  xdg-utils,
  zlib,

  commandLineArgs ? "",
}:

let
  version = "0.16.5.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
      hash = "sha256:f615a7735663584364086a2be93f0e79ba1238a856be6ddbb5aef73e7c94a970";
    };
    aarch64-linux = {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64_linux.tar.xz";
      hash = "sha256:d6b66411ad3666eb0b217724447dd172887a1d42b0e944646c4fc5fc5cdf9c1c";
    };
  };

  runtimeLibs = [
    alsa-lib
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libGL
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    mesa
    nspr
    nss
    pango
    pipewire
    systemd
    vulkan-loader
    wayland
    zlib
    stdenv.cc.cc.lib
  ];
in

stdenv.mkDerivation {
  pname = "helium";
  inherit version;

  src = fetchurl {
    url =
      sources.${stdenv.hostPlatform.system}.url
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = sources.${stdenv.hostPlatform.system}.hash;
  };

  nativeBuildInputs = [
    makeWrapper
    patchelf
  ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/helium
    cp -r * $out/lib/helium/

    rpath="${lib.makeLibraryPath runtimeLibs}:$out/lib/helium"

    for exe in helium helium_crashpad_handler chromedriver; do
      if [ -f "$out/lib/helium/$exe" ]; then
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "$rpath" \
          "$out/lib/helium/$exe" || true
      fi
    done

    # Desktop file
    mkdir -p $out/share/applications
    if [ -f "$out/lib/helium/helium.desktop" ]; then
      cp "$out/lib/helium/helium.desktop" "$out/share/applications/helium.desktop"
      substituteInPlace "$out/share/applications/helium.desktop" \
        --replace-warn 'Exec=helium' "Exec=$out/bin/helium"
    fi

    # Icons
    mkdir -p $out/share/icons/hicolor/256x256/apps
    if [ -f "$out/lib/helium/product_logo_256.png" ]; then
      cp "$out/lib/helium/product_logo_256.png" "$out/share/icons/hicolor/256x256/apps/helium.png"
    fi

    # Wrapper
    mkdir -p $out/bin
    makeWrapper "$out/lib/helium/helium" "$out/bin/helium" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      ${lib.optionalString (commandLineArgs != "") "--add-flags ${lib.escapeShellArg commandLineArgs}"}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://helium.computer";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "helium";
  };
}
