# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

let
    sourceDatasets = [
        "galaxy-${config.networking.hostName}/apps"
        "galaxy-${config.networking.hostName}/frontier"
        "galaxy-${config.networking.hostName}/wilds"
    ];
    ## Replace with your remote backup host
    sshHost = "fm2096.rsync.net";
    sshKeyPath = "/home/ranka/.ssh/id_ed25519";
    sshKeyService = {
        enable = true;
        description = "Generate SSH key for user ranka if it doesn't exist";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            User = "ranka";
            ExecStart = "/etc/nixos/ranka-ssh-key.sh ${sshKeyPath}";
            StandardOutput = "journal";
            StandardError = "journal";
            Type = "oneshot";
        };
    };
in
{
    
#    systemd.services.snapshots = {
#        enable = true;
#        description = "ZFS Send Snapshots to remote host";
#        serviceConfig = {
#            ExecStart = ''
#                /etc/nixos/snapshots.sh ${sshHost} ${sshKeyPath} "zfs-auto-snap_hourly" "galaxy-${config.networking.hostName}/frontier"
#            '';
#            Timer = {
#                OnCalendar = "*-*-* *:00:00";
#                Persistent = true;
#            };
#        };
#    };
    systemd.services.ranka-ssh-key = sshKeyService;
}