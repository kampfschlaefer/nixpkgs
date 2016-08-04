# Test the firewall module.

import ./make-test.nix ( { pkgs, lib, ... } : {
  name = "tor";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampfschlaefer ];
  };

  nodes =
    {
      tornode = {config, pkgs, nodes, ...}:
      {
        virtualisation.vlans = [ 1 ];

        networking.defaultGateway = lib.mkOverride 10 null ;
        networking.nameservers = lib.mkOverride 10 [ "8.8.8.8" ];
        /*environment.systemPackages = [];*/
      };
      /*walled =
        { config, pkgs, nodes, ... }:
        { networking.firewall.enable = true;
          networking.firewall.logRefusedPackets = true;
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
        };

      attacker =
        { config, pkgs, ... }:
        { services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.enable = false;
        };*/
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      $tornode->waitForUnit("network.target");

      $tornode->execute("ip a >&2");
      $tornode->execute("ip r >&2");

      $tornode->succeed("ping -n -c 1 8.8.8.8 >&2");
    '';

      /*$walled->waitForUnit("firewall");
      $walled->waitForUnit("httpd");
      $attacker->waitForUnit("network.target");

      # Local connections should still work.
      $walled->succeed("curl -v http://localhost/ >&2");

      # Connections to the firewalled machine should fail, but ping should succeed.
      $attacker->fail("curl --fail --connect-timeout 2 http://walled/ >&2");
      $attacker->succeed("ping -c 1 walled >&2");

      # Outgoing connections/pings should still work.
      $walled->succeed("curl -v http://attacker/ >&2");
      $walled->succeed("ping -c 1 attacker >&2");

      # If we stop the firewall, then connections should succeed.
      $walled->stopJob("firewall");
      $attacker->succeed("curl -v http://walled/ >&2");
    '';*/
})
