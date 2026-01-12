{
  plugins.copilot-lua.enable = true;
  plugins.copilot-lua.settings.suggestion.enabled = false;
  plugins.copilot-lua.settings.panel.enabled = false;

  plugins.copilot-chat.enable = true;
  plugins.copilot-cmp.enable = true;

  keymaps = [
    {
      action = "<cmd>CopilotChatToggle<cr>";
      key = "<leader>cc";
      options.desc = "Toggle Copilot Chat";
    }
    {
      action = "<cmd>CopilotChatExplain<cr>";
      key = "<leader>ce";
      options.desc = "Explain Code";
    }
    {
      action = "<cmd>CopilotChatFix<cr>";
      key = "<leader>cf";
      options.desc = "Fix Code";
    }
    {
      action = "<cmd>CopilotChatTests<cr>";
      key = "<leader>ct";
      options.desc = "Generate Tests";
    }
  ];
}
