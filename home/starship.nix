{
  programs.starship = {
    enable = true;
    settings = {
      format = "[](bg:#24273a fg:#363a4f)[ ](bg:#363a4f fg:#cad3f5)[](fg:#363a4f bg:#494d64)[](fg:#494d64 bg:#363a4f)$directory([](fg:#363a4f bg:#494d64)[](fg:#494d64 bg:#363a4f)$git_branch$git_status$git_metrics)[](bg:#24273a fg:#363a4f)$character";
      directory = {
        format = "[   $path ]($style)";
        style = "fg:#cad3f5 bg:#363a4f";
      };
      git_branch = {
        format = "[ $symbol$branch(:$remote_branch) ]($style)";
        symbol = " ";
        style = "fg:#cad3f5 bg:#363a4f";
      };
      git_status = {
        format = "[$all_status]($style)";
        style = "fg:#cad3f5 bg:#363a4f";
      };
      git_metrics = {
        disabled = false;
        format = "(([ +$added]($added_style))([ -$deleted]($deleted_style))[ ](fg:#cad3f5 bg:#363a4f))";
        added_style = "fg:#a6da95 bg:#363a4f";
        deleted_style = "fg:#ed8796 bg:#363a4f";
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
