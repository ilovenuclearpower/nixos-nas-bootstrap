# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

let
    sourceDatasets = [
        "galaxy-${config.networking.hostName}/apps"
        "galaxy-${config.networking.hostName}/frontier"
        "galaxy-${config.networking.hostName}/wilds"
    ];

    destinationDirectory = "/path/to/remote/directory";
    ## Replace with your remote backup host
    sshHost = "fm2096.rsync.net";
    sshKeyPath = "/home/ranka/.ssh/id_ed25519";
    sshKeyService = {
        enable = true;
        description = "Generate SSH key for user ranka if it doesn't exist";
        serviceConfig = {
            User = "ranka";
            ExecStartPre = ''[ -f ${sshKeyPath} ]'';
            ExecStart = ''
                ssh-keygen -t ed25519 -f ${sshKeyPath} -N ""
            '';
        };
    };
in
{
    
    services.systemd.services.snapshots = {
        enable = true;
        description = "ZFS Send Snapshots to remote host";
        serviceConfig = {
            ExecStart = ''
                /etc/nixos/snapshots.sh ${sshHost} ${sshKeyPath} "zfs-auto-snap_hourly" ${sourceDatasets}
            '';
            Timer = {
                OnCalendar = "*-*-* *:00:00";
                Persistent = true;
            };
        };
    };
    services.systemd.services.ranka-ssh-key = sshKeyService;
}