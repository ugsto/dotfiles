{
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile = {
        enabled = true;
      };
      dashboard = {
        enabled = true;
      };
      explorer = {
        enabled = true;
      };
      indent = {
        enabled = true;
      };
      input = {
        enabled = true;
      };
      notifier = {
        enabled = true;
        timeout = 3000;
      };
      picker = {
        enabled = true;
      };
      quickfile = {
        enabled = true;
      };
      scope = {
        enabled = true;
      };
      statuscolumn = {
        enabled = true;
      };
      words = {
        enabled = true;
      };
    };
  };

  keymaps = [
    {
      action = "<cmd>lua Snacks.picker.smart()<cr>";
      key = "<leader><leader>";
    }
    {
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      key = "<leader>,";
    }
    {
      action = "<cmd>lua Snacks.picker.grep()<cr>";
      key = "<leader>/";
    }
    {
      action = "<cmd>lua Snacks.picker.command_history()<cr>";
      key = "<leader>:";
    }
    {
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      key = "<leader>fb";
    }
    {
      action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath(\"config\") })<cr>";
      key = "<leader>fc";
    }
    {
      action = "<cmd>lua Snacks.picker.files()<cr>";
      key = "<leader>ff";
    }
    {
      action = "<cmd>lua Snacks.picker.git_files()<cr>";
      key = "<leader>fg";
    }
    {
      action = "<cmd>lua Snacks.picker.projects()<cr>";
      key = "<leader>fp";
    }
    {
      action = "<cmd>lua Snacks.picker.recent()<cr>";
      key = "<leader>fr";
    }
    {
      action = "<cmd>lua Snacks.picker.git_branches()<cr>";
      key = "<leader>gb";
    }
    {
      action = "<cmd>lua Snacks.picker.git_log()<cr>";
      key = "<leader>gl";
    }
    {
      action = "<cmd>lua Snacks.picker.git_log_line()<cr>";
      key = "<leader>gL";
    }
    {
      action = "<cmd>lua Snacks.picker.git_status()<cr>";
      key = "<leader>gs";
    }
    {
      action = "<cmd>lua Snacks.picker.git_stash()<cr>";
      key = "<leader>gS";
    }
    {
      action = "<cmd>lua Snacks.picker.git_diff()<cr>";
      key = "<leader>gd";
    }
    {
      action = "<cmd>lua Snacks.lazygit()<cr>";
      key = "<leader>gg";
    }
    {
      action = "<cmd>Snacks.picker.lsp_definitions()<cr>";
      key = "gd";
    }
    {
      action = "<cmd>Snacks.picker.lsp_declarations()<cr>";
      key = "gD";
    }
    {
      action = "<cmd>Snacks.picker.lsp_references()<cr>";
      key = "gr";
    }
    {
      action = "<cmd>Snacks.picker.lsp_implementations()<cr>";
      key = "gI";
    }
    {
      action = "<cmd>Snacks.picker.lsp_type_definitions()<cr>";
      key = "gy";
    }
    {
      action = "<cmd>Snacks.picker.lsp_symbols()<cr>";
      key = "<leader>ss";
    }
    {
      action = "<cmd>Snacks.picker.lsp_workspace_symbols()<cr>";
      key = "<leader>sS";
    }
    {
      action = "<cmd>lua Snacks.explorer()<cr>";
      key = "<leader>e";
    }
  ];
}
