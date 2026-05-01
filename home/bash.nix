{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza --color=auto --icons --group-directories-first";
      cat = "bat";
      k = "kubectl";
      ".." = "cd ..";
    };
    historyControl = [
      "erasedups"
      "ignoredups"
      "ignorespace"
    ];
    historySize = 10000;
    initExtra = ''
      set -o vi

      case ":$PATH:" in
        *:"$HOME/.cargo/bin":*) ;;
        *) PATH="$PATH:$HOME/.cargo/bin" ;;
      esac

      if command -v tmux >&- && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
      fi
    '';
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
