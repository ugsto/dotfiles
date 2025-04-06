{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza --color=auto --icons --group-directories-first";
      cat = "bat";
      k = "kubectl";
    };
    initExtra = ''
      set -o vi

      if command -v tmux >&- && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
      fi
    '';
  };
}
