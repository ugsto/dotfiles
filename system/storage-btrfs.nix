{
  pkgs,
  ...
}:
let
  btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
  find = "${pkgs.findutils}/bin/find";
  sort = "${pkgs.coreutils}/bin/sort";
  awk = "${pkgs.gawk}/bin/awk";
  snapshot = pkgs.writeShellScript "btrfs-snapshot" ''
    set -euo pipefail

    timestamp="$(${pkgs.coreutils}/bin/date --utc +%Y-%m-%dT%H-%M-%SZ)"

    for spec in "root:/" "home:/home"; do
      name="''${spec%%:*}"
      source="''${spec#*:}"
      destination="/.snapshots/$name/$timestamp"
      ${pkgs.coreutils}/bin/mkdir -p "''${destination%/*}"
      ${btrfs} subvolume snapshot -r "$source" "$destination"
    done

    for name in root home; do
      while read -r snapshot_path; do
        [ -n "$snapshot_path" ] || continue
        ${btrfs} subvolume delete "$snapshot_path"
      done < <(
        ${find} "/.snapshots/$name" -mindepth 1 -maxdepth 1 -type d -name '20??-??-??T??-??-??Z' -printf '%T@ %p\n' \
          | ${sort} -nr \
          | ${awk} 'NR > 14 { sub(/^[^ ]+ /, ""); print }'
      )
    done
  '';
in
{
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "weekly";
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  systemd = {
    tmpfiles.rules = [
      "d /.snapshots 0700 root root -"
      "d /.snapshots/root 0700 root root -"
      "d /.snapshots/home 0700 root root -"
    ];

    services.btrfs-snapshot = {
      description = "Create read-only Btrfs snapshots";
      wants = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
      unitConfig.RequiresMountsFor = [
        "/"
        "/home"
        "/.snapshots"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = snapshot;
      };
    };

    timers.btrfs-snapshot = {
      description = "Daily Btrfs snapshots";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 03:15:00";
        Persistent = true;
      };
    };
  };
}
