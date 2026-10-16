{ pkgs, ... }:
{
  plugins = {
    lsp-lines = {
      enable = true;
    };
    helm = {
      enable = true;
    };
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        bashls.enable = true;
        html.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
        ts_ls.enable = true;
        marksman.enable = true;
        ruff.enable = true;
        ty.enable = true;
        gopls.enable = true;
        terraformls = {
          enable = true;
          onAttach = {
            function = ''
              client.server_capabilities.semanticTokensProvider = nil
            '';
          };
        };
        ansiblels = {
          enable = true;
          package = null;
        };
        jsonls.enable = true;
        dockerls.enable = true;
        clangd = {
          enable = true;
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
            "cuda"
          ];
        };
        protols.enable = true;
        svelte.enable = true;
        helm_ls = {
          enable = true;
          extraOptions = {
            settings = {
              "helm_ls" = {
                yamlls = {
                  path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
                };
              };
            };
          };
        };
        yamlls = {
          enable = true;
          extraOptions = {
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "*.yaml";
                  "https://json.schemastore.org/github-workflow" = ".github/workflows/*";
                  "https://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                  "https://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                  "https://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                  "https://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                  "https://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                  "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                    "*docker-compose*.{yml,yaml}";
                  "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                    "*flow*.{yml,yaml}";
                };
              };
            };
          };
        };
        ruby_lsp.enable = true;
        rubocop.enable = true;
      };

      keymaps = {
        silent = true;
        lspBuf = {
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "]d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "[d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    ansible-vim
  ];

  extraConfigLua = ''
    vim.filetype.add({
      extension = {
        tf = "terraform",
        tfvars = "terraform-vars",
        hcl = "hcl",
      },
    })

    vim.o.winborder = "rounded"
  '';
}
