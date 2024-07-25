{ config, pkgs, ... }:

let
    control-1 = {
        name = "galaxy-controlplane-1";
        memory = 1024;
        vcpus = 1;
        diskSize = 20;
        iso = pkgs.fetchurl {
            url = "https://github.com/siderolabs/talos/releases/download/v1.7.5/talosctl-linux-amd64";
            sha256 = "285a8d8d2a0601e4e9ff55972afb9bc0b4f23745d56dfa96e10cc3bafa13de26";
        };
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:01";
            ip = "192.168.1.101";
            gateway = "192.168.1.1";
        };
    };

    control-2 = {
        name = "galaxy-controlplane-2";
        memory = 1024;
        vcpus = 1;
        diskSize = 20;
        iso = pkgs.fetchurl {
            url = "https://github.com/siderolabs/talos/releases/download/v1.7.5/talosctl-linux-amd64";
            sha256 = "285a8d8d2a0601e4e9ff55972afb9bc0b4f23745d56dfa96e10cc3bafa13de26";
        };
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:02";
            ip = "192.168.1.102";
            gateway = "192.168.1.1";
        };
    };

    control-3 = {
        name = "galaxy-controlplane-3";
        memory = 1024;
        vcpus = 1;
        diskSize = 20;
        iso = pkgs.fetchurl {
            url = "https://github.com/siderolabs/talos/releases/download/v1.7.5/talosctl-linux-amd64";
            sha256 = "285a8d8d2a0601e4e9ff55972afb9bc0b4f23745d56dfa96e10cc3bafa13de26";
        };
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:03";
            ip = "192.168.1.103";
            gateway = "192.168.1.1";
        };
    };
    worker-1 = {
        name = "galaxy-worker-1";
        memory = 1024;
        vcpus = 1;
        diskSize = 10;
        iso = pkgs.fetchurl {
            url = "https://github.com/siderolabs/talos/releases/download/v1.7.5/talosctl-linux-amd64";
            sha256 = "285a8d8d2a0601e4e9ff55972afb9bc0b4f23745d56dfa96e10cc3bafa13de26";
        };
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:04";
            ip = "192.168.1.104";
            gateway = "192.168.1.1";
        };
    };

    worker-2 = {
        name = "galaxy-worker-2";
        memory = 1024;
        vcpus = 1;
        diskSize = 10;
        iso = pkgs.fetchurl {
            url = "https://github.com/siderolabs/talos/releases/download/v1.7.5/talosctl-linux-amd64";
            sha256 = "285a8d8d2a0601e4e9ff55972afb9bc0b4f23745d56dfa96e10cc3bafa13de26";
        };
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:05";
            ip = "192.168.1.105";
            gateway = "192.168.1.1";
        };
    };

    worker-3 = {
        name = "galaxy-worker-3";
        memory = 1024;
        vcpus = 1;
        diskSize = 10;
        iso = pkgs.fetchurl {
            url = "https://github.com/siderolabs/talos/releases/download/v1.7.5/talosctl-linux-amd64";
            sha256 = "285a8d8d2a0601e4e9ff55972afb9bc0b4f23745d56dfa96e10cc3bafa13de26";
        };
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:06";
            ip = "192.168.1.106";
            gateway = "192.168.1.1";
        };
    };
in
{
    imports = [
        <nixpkgs/nixos/modules/virtualisation/libvirtd.nix>
    ];

    virtualisation.libvirtd = {
        enable = true;
        virtmanager = true;
        qemu = {
            enable = true;
            user = "root";
        };
        guests = [
            {
                name = control-1.name;
                memory = control-1.memory;
                vcpus = control-1.vcpus;
                diskSize = control-1.diskSize;
                iso = control-1.iso;
                network = control-1.network;
            }
            {
                name = control-2.name;
                memory = control-2.memory;
                vcpus = control-2.vcpus;
                diskSize = control-2.diskSize;
                iso = control-2.iso;
                network = control-2.network;
            }
            {
                name = control-3.name;
                memory = control-3.memory;
                vcpus = control-3.vcpus;
                diskSize = control-3.diskSize;
                iso = control-3.iso;
                network = control-3.network;
            }
        ];
    };
}