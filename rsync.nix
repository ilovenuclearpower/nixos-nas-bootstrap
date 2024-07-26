# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

let
    sourceDatasets = [
        "galaxy-${config.networking.hostName}/apps"
        "galaxy-${config.networking.hostName}/frontier"
        "galaxy-${config.networking.hostName}/wilds"
    ];
    ## Replace with your remote backup host
    sshHost = "fm2096@fm2096.rsync.net";
    sshKeyPath = "/home/root/.ssh/backup";
    sshKeyService = {
        enable = true;
        description = "Generate SSH key for user ranka if it doesn't exist";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            ExecStart="/etc/nixos/user-ssh-key.sh ${sshKeyPath}";
            StandardOutput="journal";
            StandardError="journal";
            Type="oneshot";
            Environment = "PATH=$PATH:/run/current-system/sw/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/bin:/sbin:/usr/bin:/usr/sbin";
        };
    };
in
{
    systemd.timers.snapshots = {
        enable = true;
        description = "ZFS Send Snapshots to remote host";
        timerConfig = {
            OnCalendar = "*-*-* *:15:00";
            Persistent = true;
            Unit = "snapshots.service";
        };
        wantedBy = [ "timers.target" ];
    };
    systemd.services.root-ssh-key = sshKeyService;
}