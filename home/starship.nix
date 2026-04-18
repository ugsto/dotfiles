{ theme, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = "[](bg:${theme.colors.base} fg:${theme.colors.surface0})[ ](bg:${theme.colors.surface0} fg:${theme.colors.text})[](fg:${theme.colors.surface0} bg:${theme.colors.surface1})[](fg:${theme.colors.surface1} bg:${theme.colors.surface0})$directory([](fg:${theme.colors.surface0} bg:${theme.colors.surface1})[](fg:${theme.colors.surface1} bg:${theme.colors.surface0})$git_branch$git_status$git_metrics)[](bg:${theme.colors.base} fg:${theme.colors.surface0})$character";
      directory = {
        format = "[   $path ]($style)";
        style = "fg:${theme.colors.text} bg:${theme.colors.surface0}";
      };
      git_branch = {
        format = "[ $symbol$branch(:$remote_branch) ]($style)";
        symbol = " ";
        style = "fg:${theme.colors.text} bg:${theme.colors.surface0}";
      };
      git_status = {
        format = "[$all_status]($style)";
        style = "fg:${theme.colors.text} bg:${theme.colors.surface0}";
      };
      git_metrics = {
        disabled = false;
        format = "(([ +$added]($added_style))([ -$deleted]($deleted_style))[ ](fg:${theme.colors.text} bg:${theme.colors.surface0}))";
        added_style = "fg:${theme.colors.green} bg:${theme.colors.surface0}";
        deleted_style = "fg:${theme.colors.red} bg:${theme.colors.surface0}";
      };
      hg_branch = {
        format = "[ $symbol$branch ]($style)";
        symbol = " ";
      };
      character = {
        success_symbol = "[ ➜](bold green) ";
        error_symbol = "[ ✗](#E84D44) ";
      };
    };
  };
}
