{
  lib,
  pkgs,
  pkgs-unstable,
  pkgs-custom,
  ...
}:
let
  inherit (import ./agent-sources.nix pkgs) caveman ponytail;

  skillsOf =
    src:
    let
      dir = "${src}/skills";
    in
    lib.mapAttrs' (name: _: lib.nameValuePair ".dsh/skills/${name}" { source = "${dir}/${name}"; }) (
      lib.filterAttrs (name: type: type == "directory" && builtins.pathExists "${dir}/${name}/SKILL.md") (
        builtins.readDir dir
      )
    );

  mcpServer = serverName: cfg: {
    id = "mcp-${serverName}";
    name = "@deepseek-ai/dsh-mcp-client";
    config = {
      inherit serverName;
      transport = "stdio";
    }
    // cfg;
  };

  hooksBridge = id: configPath: pluginRoot: {
    inherit id;
    name = "@deepseek-ai/dsh-hooks-claude-code";
    config = {
      configPath = toString configPath;
    }
    // lib.optionalAttrs (pluginRoot != null) { pluginRoot = toString pluginRoot; };
  };

  ponytailHooks = pkgs.writeText "ponytail-hooks.json" (
    builtins.replaceStrings [ "process.env.CLAUDE_PLUGIN_ROOT" ] [ "'${ponytail}'" ] (
      builtins.readFile "${ponytail}/hooks/claude-codex-hooks.json"
    )
  );

  homeHooks = pkgs.writeText "dsh-hooks.json" (
    builtins.toJSON {
      hooks.UserPromptSubmit = [
        {
          hooks = [
            {
              type = "command";
              command = "PATH=${
                lib.makeBinPath [ pkgs.coreutils ]
              }:$PATH ${lib.getExe pkgs-unstable.codegraph} prompt-hook";
            }
          ];
        }
      ];
    }
  );

  providersPatch = pkgs.writeText "dsh-providers.patch.yml" (
    builtins.toJSON [
      {
        id = "llm-pi-ai";
        config.providers = {
          openrouter.apiKeyEnv = "OPENROUTER_API_KEY";
          zai.apiKeyEnv = "ZAI_API_KEY";
          minimax.apiKeyEnv = "MINIMAX_API_KEY";
          openai-codex = {
            apiKeyEnv = "OPENAI_CODEX_API_KEY";
            models = [
              { id = "gpt-5.5"; }
              { id = "gpt-6-astra"; }
              { id = "gpt-6-luna"; }
              { id = "gpt-6-sol"; }
              {
                id = "gpt-6.1-sol";
                name = "GPT-6.1 Sol";
                reasoning = true;
                input = [
                  "text"
                  "image"
                ];
                contextWindow = 272000;
                maxTokens = 128000;
              }
            ];
          };
        };
      }
    ]
  );
in
{
  home.packages = [
    pkgs.pnpm
    (pkgs.writeShellScriptBin "dsh-tui" ''exec ${lib.getExe pkgs-custom.deepseek-harness} --profile dsh-tui "$@"'')
  ];

  home.activation.dshProviders = lib.hm.dag.entryAfter [ "dshTui" ] ''
    f="$HOME/.dsh/profiles/dsh-tui/cordis.patch.yml"
    if [ -d "$(dirname "$f")" ] && ! grep -q llm-pi-ai "$f"; then
      run install -m644 ${providersPatch} "$f"
    fi
  '';

  home.activation.dshTui = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.dsh/profiles/dsh-tui/node_modules/@deepseek-harness-tui" ]; then
      PATH=${
        lib.makeBinPath [
          pkgs.pnpm
          pkgs.nodejs
          pkgs-custom.deepseek-harness
        ]
      }:$PATH
      add() { run dsh plugin --profile dsh-tui add @deepseek-harness-tui/dsh-tui; }
      if ! add; then
        # pnpm >=11 blocks dependency install scripts (ERR_PNPM_IGNORED_BUILDS); none are needed at runtime.
        ws="$HOME/.dsh/profiles/dsh-tui/pnpm-workspace.yaml"
        if [ -f "$ws" ] && ! grep -q allowBuilds "$ws"; then
          printf "\nallowBuilds:\n  '@google/genai': false\n  protobufjs: false\n" >> "$ws"
        fi
        add || echo "dsh-tui install failed; retry on next switch" >&2
      fi
    fi
  '';

  # Community plugins from the awesome-dsh-plugins editor's picks. The web profile is also the
  # kernel dsh-tui runs sessions on. Needs dsh >=0.2.1-rc.2 (sidebar 0.28, web-all 0.4.7).
  home.activation.dshPlugins = lib.hm.dag.entryAfter [ "dshTui" ] ''
    PATH=${
      lib.makeBinPath [
        pkgs.pnpm
        pkgs.nodejs
        pkgs-custom.deepseek-harness
      ]
    }:$PATH
    plug() { # profile package dir
      [ -d "$HOME/.dsh/profiles/$1/node_modules/$3" ] || run dsh plugin --profile "$1" add "$2" \
        || echo "dsh plugin $2 ($1) failed; retry on next switch" >&2
    }
    web="$HOME/.dsh/profiles/web"
    # pnpm >=11 blocks dependency install scripts; the sidebar's native extras are not needed at runtime.
    if [ -d "$web" ] && ! grep -q allowBuilds "$web/pnpm-workspace.yaml"; then
      printf "\nallowBuilds:\n  cloudflared: false\n  cpu-features: false\n  ssh2: false\n" >> "$web/pnpm-workspace.yaml"
    fi
    # 0.2.1 ships the hook bridges only as devDependencies, so the home patch needs them per profile
    for p in web dsh-tui; do
      plug $p @deepseek-ai/dsh-hook-protocol@0.2.1-rc.2 @deepseek-ai/dsh-hook-protocol
      plug $p @deepseek-ai/dsh-hooks-claude-code@0.2.1-rc.2 @deepseek-ai/dsh-hooks-claude-code
    done
    # bundles: native subagents, session search, git worktree, Agent Teams (the team bundle disables the plain subagent tools)
    for p in web dsh-tui; do
      for b in dsh-subagent-claude-code dsh-subagent-codex dsh-experimental-session-search dsh-experimental-tool-worktree dsh-experimental-agent-team-profile; do
        plug $p @deepseek-ai/$b@0.2.1-rc.2 @deepseek-ai/$b
      done
    done
    plug web dsh-mnemon dsh-mnemon
    plug web dsh-better-sidebar@0.28.0 dsh-better-sidebar
    plug web @linxin666/dsh-web-all@0.4.7 @linxin666/dsh-web-all
    plug dsh-tui dsh-mnemon dsh-mnemon
  '';

  home.file = {
    ".dsh/AGENTS.md".text = ''
      # Command output

      Always prefix shell commands with `rtk` (e.g. `rtk git status`, `rtk cargo test`).
      It condenses output to save tokens, keeping every signal and dropping noise. Treat
      the result as complete and batch related commands into one call. Run `rtk proxy <cmd>`
      only when a result is unusable: empty when output was clearly expected, contradicting
      its exit code, or garbled.

      ## CodeGraph

      In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

      - **MCP tool** (when available): `mcp__codegraph__codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source.
      - **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

      If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.

      ## Working rules

      - Ponytail mode (full) is always on, since dsh does not fire SessionStart hooks: make the smallest complete change, reuse existing code, add no unrequested abstraction, and end replies with one or two lines on what was skipped or unchecked and any risk.
      - Do not re-read a file already in context unless it changed since.
      - For structural code search or rewrites (call shapes, imports, syntax patterns) use `ast-grep` instead of text grep.
      - Never run destructive subcommands (`helm uninstall`, `kubectl delete`, `terraform destroy`) without asking first.
    '';

    ".dsh/cordis.patch.yml".text = builtins.toJSON [
      # web-all extras not wanted: the pet, and the usage tab with its CNY-only spend card (no currency option)
      {
        id = "web-ui-pet";
        disabled = true;
      }
      {
        id = "web-ui-usage";
        disabled = true;
      }
      # LiangShen mode (PTC persona preset) and the skin center, whose built-in blue-fantasy skin paints a full-screen wallpaper
      {
        id = "web-ui-liangshen";
        disabled = true;
      }
      {
        id = "web-ui-skin-center";
        disabled = true;
      }
      {
        insert = [
          (mcpServer "codegraph" {
            command = lib.getExe pkgs-unstable.codegraph;
            env.PATH = lib.makeBinPath [ pkgs.coreutils ];
            args = [
              "serve"
              "--mcp"
            ];
          })
          (mcpServer "affine" {
            command = "affine-mcp";
            env.AFFINE_TOOL_PROFILE = "core";
          })
          (hooksBridge "hooks-home" homeHooks null)
          (hooksBridge "hooks-caveman" "${caveman}/.claude-plugin/plugin.json" caveman)
          (hooksBridge "hooks-ponytail" ponytailHooks ponytail)
        ];
      }
    ];
  }
  // skillsOf caveman
  // skillsOf ponytail;
}
