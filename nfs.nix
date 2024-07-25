# /etc/nixos/nfs.nix

{ config, pkgs, ... }:

let
    # Define the directories to be shared
    publicFileSystems = [
        { name = "media"; path = "/media"; }
        { name = "frontier"; path = "/frontier"; }
    ];

    privateFileSystems = [
        { name = "wilds"; path = "/wilds"; }
        { name = "apps"; path = "/apps"; }
    ];

    # Define the usergroups allowed to access the shares
    privateUserGroups = [ "ranka" "frontier" "apps" ];
    publicUserGroups  = [ "wilds" "media" ];
    systemUserGroups = [ "ranka" "wheel" ];
    # Generate the NFS exports configuration
    nfsExports = builtins.concatStringsSep "\n" (map (share: ''
        ${share.path} *(rw,sync,no_subtree_check,no_root_squash)
    '') (publicFileSystems ++ privateFileSystems));

    # Generate the Samba shares configuration
    publicShares = builtins.listToAttrs (map (share: {
            name = share.name;
            value = {
            path = "${share.path}";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
            "browseable" = "yes";
            "valid users" = builtins.concatStringsSep " " (map (group: "@${group}") (publicUserGroups ++ privateUserGroups ++ systemUserGroups));
            "force group" = "${share.name}";
            };
    }) publicFileSystems);
    privateShares = builtins.listToAttrs (map (share: {
            name = share.name;
            value = {
            path = "${share.path}";
            "read only" = "no";
            "guest ok" = "no";
            "browseable" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
            "valid users" = builtins.concatStringsSep " " (map (group: "@${group}") (privateUserGroups ++ systemUserGroups));
            "force group" = "${share.name}";
            };
    }
    ) privateFileSystems);
in
{   
    # Add the NFS exports configuration
    services.nfs.server = {
        enable = true;
        exports = nfsExports;
   };
    networking.firewall.extraCommands = ''
        iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
        iptables -A INPUT -p tcp --dport 445 -j ACCEPT
        iptables -A OUTPUT -p tcp --sport 445 -j ACCEPT
    '';


    # Add the Samba shares configuration
    services.samba = {
    extraConfig = ''
        workgroup = WORKGROUP
        server string = ${config.networking.hostName}
        netbios name = ${config.networking.hostName}
        security = user 
        hosts allow = 192.168.10. 192.168.20. 127.0.0.1 localhost 192.168.88. 10.0.
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
        encrypt passwords = yes
    '';
        enable = true;
        shares = publicShares // privateShares;
    };
    services.samba-wsdd = {
        enable = true;
        openFirewall = true;
    };

}