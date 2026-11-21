{
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (import ./agent-sources.nix pkgs)
    caveman
    ponytail
    mattpocock-skills
    rtkContext
    ;
  claude-plugins-official = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-plugins-official";
    rev = "f359d43b406057f1a8cdbc4ea93b827642c162e6";
    hash = "sha256-f5mnVFXVkaMoahQv5pu5fS0gGV1uaowi/mpJM0gm/I8=";
  };

  aseprite-mcp = pkgs.fetchFromGitHub {
    owner = "diivi";
    repo = "aseprite-mcp";
    rev = "4bcdb6f5932116bbdbd1b7d3fcc1e8f965f7657a";
    hash = "sha256-RzmKOVsSYcnTnuNn7qu/zu7FwrIV1lJ0Sv5JYisUVaE=";
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

    file.".claude/RTK.md".text = rtkContext;
  };

  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;

    skills = ./skills;

    context = ''
      @RTK.md

      ## Long-term memory

      Long-term memory is the AFFiNE workspace "AGENTS", reached through the `affine` MCP tools. Use the skills; do not improvise.

      - `memory-read`: use it at the start of almost every session and task, before answering anything that past decisions, user preferences or project gotchas could change. Skip it only for questions that need no context at all.
      - `memory-write`: use it when you learn something durable that is not derivable from code or git: a user correction or preference, a decision and its reason, a gotcha, a runbook, an external pointer. Write it as soon as it happens, not at the end. Never write secrets.
      - `memory-daydream` is the user's background job. Never run it yourself.
      - Memory is a claim from a past date. Verify files, flags and commands it names before relying on them. If the `affine` tools are unavailable, say so and go on without memory; do not invent it.

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
      mattpocock-skills
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

    # Needs the FreeCAD "MCP" addon (neka-nat/freecad-mcp, addon/FreeCADMCP) in ~/.local/share/FreeCAD/Mod with its RPC server started.
    mcpServers.freecad = {
      type = "stdio";
      command = "${pkgs.uv}/bin/uvx";
      # NixOS can't run uv's downloaded generic Pythons; use the nix one.
      args = [ "--python" "${pkgs.python3}/bin/python3" "freecad-mcp" ];
      env.UV_PYTHON_DOWNLOADS = "never";
    };

    # Needs the Blender addon (ahujasid/blender-mcp, addon.py) installed and "Connect to Claude" started in the N-panel.
    mcpServers.blender = {
      type = "stdio";
      command = "${pkgs.uv}/bin/uvx";
      args = [ "--python" "${pkgs.python3}/bin/python3" "blender-mcp" ];
      env = {
        UV_PYTHON_DOWNLOADS = "never";
        DISABLE_TELEMETRY = "true";
      };
    };

    # No console script upstream: run the module from the store with its deps injected by uvx.
    mcpServers.aseprite = {
      type = "stdio";
      command = "${pkgs.uv}/bin/uvx";
      args = [
        "--python" "${pkgs.python3}/bin/python3"
        "--with" "httpx" "--with" "mcp[cli]<2" "--with" "pillow"
        "python" "-m" "aseprite_mcp"
      ];
      env = {
        UV_PYTHON_DOWNLOADS = "never";
        PYTHONPATH = "${aseprite-mcp}";
        ASEPRITE_PATH = "${pkgs-unstable.aseprite}/bin/aseprite";
      };
    };

    mcpServers.affine = {
      type = "http";
      url = "https://affine-mcp.bortoli.phd/mcp";
      # Public Kanidm client with PKCE; it accepts http://localhost on any port.
      oauth.clientId = "affine-mcp";
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
