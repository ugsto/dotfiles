{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,

  alsa-lib,
  ffmpeg,
  pipewire,

  atk,
  cairo,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  mesa,
  pango,
  wayland,

  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libxcb,
  libxkbcommon,

  cups,
  curl,
  dbus,
  nspr,
  nss,
  systemd,
}:

let
  version = "140.8.0esr-bb19";

  sources = {
    x86_64-linux = {
      url = "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${version}.en-US.linux-x86_64.tar.xz";
      hash = "sha256:06p6bfhilnrai80pcwy6l9zxqibsbband785x210pdmk2g9l1gj8";
    };
  };

  runtimeLibs = [
    alsa-lib
    ffmpeg
    pipewire

    atk
    cairo
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    mesa
    pango
    wayland

    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    libxkbcommon

    cups
    curl
    dbus
    nspr
    nss
    stdenv.cc.cc.lib
    systemd
  ];

in
stdenv.mkDerivation {
  pname = "betterbird";
  inherit version;

  src = fetchurl {
    url = sources.${stdenv.system}.url or (throw "Unsupported system: ${stdenv.system}");
    sha256 = sources.${stdenv.system}.hash;
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = runtimeLibs;

  desktopItems = [
    (makeDesktopItem {
      name = "betterbird";
      exec = "betterbird %u";
      icon = "betterbird";
      desktopName = "Betterbird";
      genericName = "Email Client";
      comment = "Betterbird Email Client - A fine-tuned Thunderbird clone";
      categories = [
        "Network"
        "Email"
      ];
      startupNotify = true;
      startupWMClass = "betterbird";
      mimeTypes = [
        "message/rfc822"
        "x-scheme-handler/mailto"
      ];
    })
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/betterbird
    cp -r * $out/lib/betterbird/

    for exe in betterbird betterbird-bin rnpkeys; do
      if [ -f "$out/lib/betterbird/$exe" ]; then
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 "$out/lib/betterbird/$exe" || true
      fi
    done

    for size in 16 22 24 32 48 64 128 256; do
      icon_dir=$out/share/icons/hicolor/''${size}x''${size}/apps
      mkdir -p $icon_dir
      if [ -f chrome/icons/default/default''${size}.png ]; then
        cp chrome/icons/default/default''${size}.png $icon_dir/betterbird.png
      fi
    done

    runHook postInstall
  '';

  preFixup = ''
    mkdir -p $out/bin
    makeWrapper $out/lib/betterbird/betterbird $out/bin/betterbird \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
  '';

  dontPatchELF = true;
  dontStrip = true;

  meta = with lib; {
    description = "Betterbird is a fine-tuned version of Mozilla Thunderbird";
    homepage = "https://www.betterbird.eu/";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "betterbird";
  };
}
