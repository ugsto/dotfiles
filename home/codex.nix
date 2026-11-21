{
  config,
  lib,
  pkgs,
  pkgs-custom,
  pkgs-unstable,
  ...
}:
let
  claude = config.programs.claude-code;
  inherit (import ./agent-sources.nix pkgs)
    caveman
    mattpocock-skills
    ponytail
    rtkContext
    ;

  skillsIn =
    dir:
    lib.mapAttrs (name: _: "${dir}/${name}") (
      lib.filterAttrs (name: type: type == "directory" && builtins.pathExists "${dir}/${name}/SKILL.md") (
        builtins.readDir dir
      )
    );

  mattpocockSkills =
    (builtins.fromJSON (builtins.readFile "${mattpocock-skills}/.claude-plugin/plugin.json")).skills;

  skills =
    skillsIn claude.skills
    // skillsIn "${caveman}/skills"
    // skillsIn "${ponytail}/skills"
    // lib.listToAttrs (
      map (path: lib.nameValuePair (baseNameOf path) "${mattpocock-skills}/${path}") mattpocockSkills
    );

  mcpServers =
    lib.mapAttrs (
      name: server:
      removeAttrs server [
        "type"
        "alwaysLoad"
        "oauth"
      ]
      // lib.optionalAttrs (name == "codegraph") {
        command = lib.getExe pkgs-unstable.codegraph;
        default_tools_approval_mode = "approve";
      }
    ) (removeAttrs claude.mcpServers [ "affine" ])
    // {
      affine = {
        command = lib.getExe pkgs-custom.mcp-remote;
        args = [
          claude.mcpServers.affine.url
          "--static-oauth-client-info"
          (builtins.toJSON {
            client_id = claude.mcpServers.affine.oauth.clientId;
            token_endpoint_auth_method = "none";
          })
          "--callback-path"
          "/callback"
        ];
        startup_timeout_sec = 60;
      };
    };

  toml = pkgs.formats.toml { };
  cavecrewAgents =
    lib.mapAttrs'
      (
        name: description:
        lib.nameValuePair ".codex/agents/${name}.toml" {
          source = toml.generate "${name}.toml" {
            inherit name description;
            developer_instructions = builtins.elemAt (lib.splitString "\n---\n" (builtins.readFile "${caveman}/agents/${name}.md")) 1;
          };
        }
      )
      {
        cavecrew-builder = "Make a surgical edit in one or two files.";
        cavecrew-investigator = "Locate code and trace its callers without editing files.";
        cavecrew-reviewer = "Review a diff and report findings by severity without editing files.";
      };

  settings = pkgs.writeText "codex-dotfiles.json" (
    builtins.toJSON {
      analytics.enabled = false;
      feedback.enabled = false;
      mcp_servers = mcpServers;
    }
  );

  python = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);

  commandHook = command: {
    type = "command";
    inherit command;
  };

  cavemanHook = {
    matcher = "startup|resume";
    hooks = [
      (
        (commandHook "${lib.getExe pkgs.nodejs} ${caveman}/.codex/codex-sessionstart.js")
        // {
          timeout = 5;
          statusMessage = "Loading caveman mode";
        }
      )
    ];
  };

  ponytailHooks = lib.mapAttrs (
    _: groups:
    map (
      group:
      group
      // {
        hooks = map (
          hook:
          hook
          // {
            command =
              ''PLUGIN_DATA="''${CODEX_HOME:-$HOME/.codex}/plugins/data/ponytail" CLAUDE_PROJECT_DIR="$PWD" ''
              +
                lib.replaceStrings
                  [ "node -e" "process.env.CLAUDE_PLUGIN_ROOT" ]
                  [ "${lib.getExe pkgs.nodejs} -e" "'${ponytail}'" ]
                  hook.command;
          }
        ) group.hooks;
      }
    ) groups
  ) (builtins.fromJSON (builtins.readFile "${ponytail}/hooks/claude-codex-hooks.json")).hooks;
in
{
  programs.codex = {
    enable = true;
    package = pkgs-unstable.codex;
    context = rtkContext + "\n" + lib.removePrefix "@RTK.md\n\n" claude.context;
  };

  home.file =
    lib.mapAttrs' (name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }) skills
    // cavecrewAgents
    // {
      ".codex/hooks.json".text = builtins.toJSON {
        hooks = ponytailHooks // {
          SessionStart = [ cavemanHook ] ++ ponytailHooks.SessionStart;
          UserPromptSubmit = ponytailHooks.UserPromptSubmit ++ [
            {
              hooks = [ (commandHook "${lib.getExe pkgs-unstable.codegraph} prompt-hook") ];
            }
          ];
          PreToolUse = [
            {
              matcher = "Bash";
              hooks = [ (commandHook "${lib.getExe pkgs-unstable.rtk} hook codex") ];
            }
          ];
        };
      };
    };

  home.activation.codexSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${python}/bin/python3 ${./merge-codex-settings.py} "$HOME/.codex/config.toml" ${settings}
  '';
}
