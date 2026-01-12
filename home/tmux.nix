{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = [
      pkgs.tmuxPlugins.catppuccin
    ];
    extraConfig = ''
      set -g prefix C-b
      set -sg escape-time 0
      set -g mouse on

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind-key H previous-window
      bind-key L next-window

      set-option -g status-position top

      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g @catppuccin_flavor 'macchiato'
      set -g @catppuccin_window_status_file "rounded"

      set -g @catppuccin_window_fill "number"
      set -g @catppuccin_window_text " #W"

      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text " #W"

      set -g @catppuccin_status_modules_right "date_time directory session"
    '';
  };
}
