{
  lib,
  stdenv,
  fetchurl,
  unzip,
  buildFHSEnv,
  makeDesktopItem,
  writeShellScript,

  alsa-lib,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  ffmpeg,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  icu,
  krb5,
  libGL,
  libappindicator-gtk3,
  libdrm,
  libgbm,
  libgcc,
  libnotify,
  libsecret,
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
  libxshmfence,
  libxslt,
  libxtst,
  libz,
  mesa,
  nspr,
  nss,
  openssl,
  pango,
  pipewire,
  systemd,
  udev,
  wayland,
  zlib,
}:

let
  version = "17";

  sources = {
    x86_64-linux = {
      url = "https://updater.grayjay.app/Apps/Grayjay.Desktop/${version}/Grayjay.Desktop-linux-x64-v${version}.zip";
      sha256 = "1m2pcwrskwp1lwpqhws0qy9ym77ii2sjf5zsv88ayc3cl99vk999";
    };
  };

  rawApp = stdenv.mkDerivation {
    pname = "grayjay-raw";
    inherit version;

    src = fetchurl {
      url = sources.x86_64-linux.url;
      sha256 = sources.x86_64-linux.sha256;
    };

    nativeBuildInputs = [ unzip ];

    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/grayjay
      cp -r * $out/opt/grayjay/
      chmod +x $out/opt/grayjay/Grayjay || true
      chmod +x $out/opt/grayjay/FUTO.Updater.Client || true
      chmod +x $out/opt/grayjay/ffmpeg || true
      if [ -d "$out/opt/grayjay/cef" ]; then
        chmod +x $out/opt/grayjay/cef/dotcefnative || true
        chmod +x $out/opt/grayjay/cef/chrome-sandbox || true
      fi
      rm -f $out/opt/grayjay/Portable || true
      ln -s /tmp/grayjay-launch $out/opt/grayjay/launch || true
      if [ -d "$out/opt/grayjay/cef" ]; then
        ln -s /tmp/grayjay-cef-launch $out/opt/grayjay/cef/launch || true
      fi
      runHook postInstall
    '';
  };

  desktopItem = makeDesktopItem {
    name = "Grayjay";
    exec = "grayjay %U";
    icon = "grayjay";
    comment = "Cross platform media application for streaming and downloading media";
    desktopName = "Grayjay Desktop";
    genericName = "Media Player";
    categories = [
      "Network"
      "AudioVideo"
      "Video"
    ];
    startupNotify = true;
    startupWMClass = "Grayjay";
    mimeTypes = [ "x-scheme-handler/grayjay" ];
  };

  fhs = buildFHSEnv {
    name = "grayjay";

    targetPkgs = pkgs: [
      alsa-lib
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      ffmpeg
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      icu
      krb5
      libGL
      libappindicator-gtk3
      libdrm
      libgbm
      libgcc
      libnotify
      libsecret
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
      libxshmfence
      libxslt
      libxtst
      libz
      mesa
      nspr
      nss
      openssl
      pango
      pipewire
      systemd
      udev
      wayland
      zlib
      pkgs.stdenv.cc.cc.lib
    ];

    runScript = writeShellScript "grayjay-run" ''
      cd "${rawApp}/opt/grayjay"
      export LD_LIBRARY_PATH="${rawApp}/opt/grayjay:${rawApp}/opt/grayjay/cef:$LD_LIBRARY_PATH"
      exec ./Grayjay "$@"
    '';

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications/

      mkdir -p $out/share/icons/hicolor/512x512/apps
      if [ -f "${rawApp}/opt/grayjay/grayjay.png" ]; then
        cp "${rawApp}/opt/grayjay/grayjay.png" "$out/share/icons/hicolor/512x512/apps/grayjay.png"
      fi

      ln -s $out/bin/grayjay $out/bin/Grayjay
    '';

    meta = with lib; {
      description = "Cross-platform application to stream and download content from various sources";
      homepage = "https://grayjay.app/desktop/";
      license = licenses.sfl;
      maintainers = [ ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "grayjay";
    };
  };
in
fhs
