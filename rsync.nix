# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

let
    sourceDatasets = [
        "/apps"
        "/frontier"
        "/wilds"
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
    
    services.systemd.services.rsync = {
        enable = true;
        description = "Rsync filesystems to remote host";
        serviceConfig = {
            User = "ranka";
            ExecStart = ''
                for dataset in ${toString sourceDatasets}; do
                    rsync -avz -e "ssh -i /home/ranka/.ssh/id_ed25519" "$dataset" "${sshHost}:${config.networking.hostName}/$dataset";
                done
            '';
        };
    };
    services.systemd.services.ranka-ssh-key = sshKeyService;
}