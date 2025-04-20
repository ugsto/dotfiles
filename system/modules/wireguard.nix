{ username, ... }:
{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "192.168.29.2/24" ];
      privateKeyFile = "/home/${username}/wireguard-keys/private";

      peers = [
        {
          publicKey = "zF/R+/NVSajqRKaZL7FRBDf1/7jIldvmYSShu3/W0ko=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "vpn.bortoli.phd:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
