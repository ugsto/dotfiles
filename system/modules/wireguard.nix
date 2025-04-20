{
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.29.1/8" ];
      listenPort = 51820;
      privateKeyFile = "~/wireguard-keys/private";
      peers = [
        {
          publicKey = "zF/R+/NVSajqRKaZL7FRBDf1/7jIldvmYSShu3/W0ko=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "vpn.bortoli.phd:51820";
          persistentKeepAlive = 25;
        }
      ];
    };
  };
}
