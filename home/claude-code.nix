{
  pkgs,
  pkgs-unstable,
  ...
}:
let
  caveman = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "2e08b9177c07bb7249a8a2d1a6758e5db281d002"; # v3.2.0
    hash = "sha256-przOot/S0VLw2aP3tOdxF27mZHMp0NQhyTls0eDAjjs=";
  };
  ponytail = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "9b58c1ffb790c075ca32e70a89cf1d80588f4abf"; # v5.1.0
    hash = "sha256-S2gHV4/c8XPDqpf0jS8Q5r22//6skZjITf2T9CVhVRE=";
  };
  claude-pro-kit = pkgs.fetchFromGitHub {
    owner = "VedantAndhale";
    repo = "claude-pro-kit";
    rev = "e4763cff1a62a9dae9fcd8f143bd71a8d6371c05";
    hash = "sha256-Ugwl3Vc8LeheMszPVTJ5sWC0OMTcV3iWFppuY7RXw4E=";
  };
  claude-code-mods = pkgs.fetchFromGitHub {
    owner = "hamzafer";
    repo = "claude-code-mods";
    rev = "11abba8c305b0d7563e1c89254c6d5e708746b47";
    hash = "sha256-wpxe+KIAZdhlhXFfllcXIR8Fle9AvWEP1M2Ny5pUW8I=";
  };
  claude-plugins-official = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-plugins-official";
    rev = "f359d43b406057f1a8cdbc4ea93b827642c162e6";
    hash = "sha256-f5mnVFXVkaMoahQv5pu5fS0gGV1uaowi/mpJM0gm/I8=";
  };

  telemetryOff = {
    DO_NOT_TRACK = "1";
    DISABLE_TELEMETRY = "1";
    DISABLE_ERROR_REPORTING = "1";
    CODEGRAPH_TELEMETRY = "0";
  };
in
{
  home = {
    packages = with pkgs-unstable; [
      rtk
      codegraph
      rust-analyzer
      typescript-language-server
      pyright
      nixd
      ccusage
      ast-grep
    ];

    sessionVariables = telemetryOff;

    file.".claude/ccusage.json".text = builtins.toJSON { defaults.offline = true; };

    file.".claude/RTK.md".text = ''
      # Command output

      Command output here is condensed to save tokens, keeping every signal and
      dropping costly noise. Treat it as the complete result: run commands
      normally, and batch related commands into one call to avoid extra turns.
      Truncated results state their recovery path in their own output. Re-run a
      command as `rtk proxy <cmd>` only when its result is unusable: empty when
      output was clearly expected, contradicting its exit code, or garbled.
    '';
  };

  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;

    context = ''
      @RTK.md

      <!-- CODEGRAPH_START -->
      ## CodeGraph

      In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

      - **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
      - **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

      If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
      <!-- CODEGRAPH_END -->
    '';

    plugins = [
      caveman
      ponytail
      "${claude-pro-kit}/plugins/output-diet"
      "${claude-pro-kit}/plugins/tool-diet"
      "${claude-pro-kit}/plugins/reread-guard"
      "${claude-code-mods}/mods/context-bar"
      "${claude-code-mods}/mods/md-preview"
      "${claude-code-mods}/mods/blast-radius"
      "${claude-code-mods}/mods/replay-theater"
      "${claude-plugins-official}/plugins/rust-analyzer-lsp"
      "${claude-plugins-official}/plugins/typescript-lsp"
      "${claude-plugins-official}/plugins/pyright-lsp"
    ];

    mcpServers.codegraph = {
      type = "stdio";
      command = "codegraph";
      args = [
        "serve"
        "--mcp"
      ];
      alwaysLoad = true;
    };

    mcpServers.affine = {
      type = "stdio";
      command = "affine-mcp";
      env.AFFINE_TOOL_PROFILE = "core";
    };

    lspServers.nix = {
      command = "nixd";
      extensionToLanguage.".nix" = "nix";
    };

    settings = {
      model = "sonnet";
      theme = "dark";
      skipDangerousModePermissionPrompt = true;
      agentPushNotifEnabled = true;
      env = telemetryOff;

      permissions.allow = [ "mcp__codegraph__*" ];

      hooks = {
        PreToolUse = [
          {
            matcher = "Bash";
            hooks = [
              {
                type = "command";
                command = "rtk hook claude";
              }
            ];
          }
        ];
        UserPromptSubmit = [
          {
            hooks = [
              {
                type = "command";
                command = "codegraph prompt-hook";
              }
            ];
          }
        ];
      };

      autoMode = {
        soft_deny = [
          "$defaults"
          "Bash(helm uninstall:*) in this repo's argocd namespace — destructive subcommand of a frequently-used CLI not covered by default labels"
        ];
        environment = builtins.fromJSON (builtins.readFile ./claude-code-auto-mode-environment.json);
      };
    };
  };
}
