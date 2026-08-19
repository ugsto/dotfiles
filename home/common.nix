{
  pkgs,
  pkgs-unstable,
  pkgs-custom,
  ...
}:
{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
    gemini-cli.enable = false;
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  home = {
    stateVersion = "26.05";
    packages = with pkgs; [
      lazygit
      android-file-transfer
      zbar
      dust
      bat
      fd
      ripgrep
      eza
      fzf
      jaq
      tcpdump
      pavucontrol
      tor
      torsocks
      bc
      kubectl
      kubectx
      kubernetes-helm
      k9s
      zotero
      libreoffice
      zoom-us
      yazi
      drawio
      hcloud
      terragrunt

      slack
      glab
      trivy
      crane

      pkgs-unstable.devenv
      pkgs-unstable.kind
      pkgs-unstable.freetube
      pkgs-unstable.ferdium
      pkgs-unstable.tor-browser
      pkgs-unstable.arduino
      pkgs-unstable.blender
      pkgs-unstable.doctl
      pkgs-unstable.openscad
      pkgs-unstable.claude-code
      pkgs-unstable.nodejs

      pkgs-custom.nvim
      pkgs-custom.betterbird
      pkgs-custom.grok
      pkgs-custom.vastai
      pkgs-custom.google-colab-cli

      nerd-fonts.fira-code
      font-awesome
      freefont_ttf
      liberation_ttf

      pkgs.ruff
      pkgs.nixfmt
      pkgs.jq
      pkgs.stylua

      pkgs.shellcheck
      pkgs.shfmt
      pkgs.shellharden
      pkgs.bicep

      (pkgs.stdenv.mkDerivation rec {
        pname = "ai-jail";
        version = "1.17.0";

        src = pkgs.fetchurl {
          url = "https://github.com/akitaonrails/${pname}/releases/download/v${version}/${pname}-linux-x86_64.tar.gz";
          hash = "sha256-uQd6SmgRlV4jk7tVOBLkBwYhJqnccQav0aJGh1wfAE4=";
        };

        sourceRoot = ".";
        dontConfigure = true;
        dontBuild = true;

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.makeBinaryWrapper
        ];

        buildInputs = [
          pkgs.stdenv.cc.cc.lib
          pkgs.openssl
          pkgs.zlib
        ];

        installPhase = ''
          runHook preInstall
          install -Dm755 ai-jail $out/bin/ai-jail
          runHook postInstall
        '';

        postFixup = ''
          wrapProgram $out/bin/ai-jail \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.bubblewrap ]} \
            --set BWRAP_BIN "${pkgs.bubblewrap}/bin/bwrap"
        '';
      })
    ];
  };

  fonts.fontconfig.enable = true;
  xdg.mime.enable = true;
  xdg.desktopEntries = { };

  programs.fzf.enableBashIntegration = true;
  programs.home-manager.enable = true;

  imports = [
    ./bash.nix
    ./chromium.nix
    ./gammastep.nix
    ./librewolf.nix
    ./matrix.nix
    ./obs.nix
    ./sops.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./wofi.nix
    ./activitywatch.nix
  ];
}
