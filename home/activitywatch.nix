{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  services.activitywatch = {
    enable = true;
    watchers = {
      aw-watcher-afk = {
        package = pkgs.activitywatch;
        settings = {
          timeout = 300;
          poll_time = 2;
        };
      };
      aw-watcher-window = {
        package = pkgs-unstable.aw-watcher-window-wayland;
        executable = "aw-watcher-window-wayland";
        name = "aw-watcher-window";
      };
    };
  };
}
