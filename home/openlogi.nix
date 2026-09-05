{ pkgs-custom, ... }:
{
  systemd.user.services.openlogi-agent = {
    Unit = {
      Description = "OpenLogi background agent (Logitech HID++ device control)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs-custom.openlogi}/bin/openlogi-agent";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
