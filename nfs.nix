# /etc/nixos/nfs.nix

{ config, pkgs, ... }:

let
    # Define the directories to be shared
    publicFileSystems = [
        { name = "apps"; path = "/apps"; }
        { name = "media"; path = "/media"; }
        { name = "frontier"; path = "/frontier"; }
    ];

    privateFileSystems = [
        { name = "wilds"; path = "/wilds"; }
        { name = "apps"; path = "/apps"; }
    ];

    # Define the usergroups allowed to access the shares
    privateUserGroups = [ "ranka" "frontier" "apps" ];
    publicUserGroup = [ "wilds" "media" ];
    systemUserGroups = [ "ranka" "wheel" ];
    # Generate the NFS exports configuration
    nfsExports = builtins.concatMap (share: ''
        ${share.path} *(rw,sync,no_subtree_check,no_root_squash)
    '') (publicFileSystems ++ privateFileSystems);

    # Generate the Samba shares configuration
    publicShares = builtins.concatMap (share: ''
        [${share.name}]
            path = ${share.path}
            read only = no
            guest ok = yes
            browseable = yes
            valid users = @${publicUserGroups} @${systemUserGroups}
            force group = ${share.name}
    '') publicFileSystems;
    privateShares = builtins.concatMap (share: ''
        [${share.name}]
            path = ${share.path}
            read only = no
            guest ok = no
            browseable = yes
            valid users = @${privateUserGroups} @${systemUserGroups}
            force group = ${share.name}
    '') privateFileSystems;
in
{   
    # Add the NFS exports configuration
    services.nfs = {
        enable = true;
        exports = nfsExports;
    };

    # Add the Samba shares configuration
    services.samba = {
        enable = true;
        shares = {
          public = publicShares;
          private = privateShares;
        };
    };
    services.samba-wsdd = {
        enable = true;
        openFirewall = true;
    };
}