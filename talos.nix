{ config, pkgs, ... }:

let
    vm1 = {
        name = "galaxy-talos-1";
        memory = 2048;
        vcpus = 2;
        diskSize = 20;
        iso = pkgs.path/to/your/iso1;
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:01";
            ip = "192.168.1.101";
            gateway = "192.168.1.1";
        };
    };

    vm2 = {
        name = "galaxy-talos-2";
        memory = 2048;
        vcpus = 2;
        diskSize = 20;
        iso = pkgs.path/to/your/iso2;
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:02";
            ip = "192.168.1.102";
            gateway = "192.168.1.1";
        };
    };

    vm3 = {
        name = "galaxy-talos-3";
        memory = 2048;
        vcpus = 2;
        diskSize = 20;
        iso = pkgs.path/to/your/iso3;
        network = {
            type = "bridge";
            bridge = "br0";
            mac = "52:54:00:00:00:03";
            ip = "192.168.1.103";
            gateway = "192.168.1.1";
        };
    };
in
{
    imports = [
        <nixpkgs/nixos/modules/virtualisation/libvirtd.nix>
    ];

    services.libvirtd.enable = true;

    virtualisation.libvirtd = {
        enable = true;
        virtmanager = true;
        qemu = {
            enable = true;
            user = "root";
        };
        guests = [
            {
                name = vm1.name;
                memory = vm1.memory;
                vcpus = vm1.vcpus;
                diskSize = vm1.diskSize;
                iso = vm1.iso;
                network = vm1.network;
            }
            {
                name = vm2.name;
                memory = vm2.memory;
                vcpus = vm2.vcpus;
                diskSize = vm2.diskSize;
                iso = vm2.iso;
                network = vm2.network;
            }
            {
                name = vm3.name;
                memory = vm3.memory;
                vcpus = vm3.vcpus;
                diskSize = vm3.diskSize;
                iso = vm3.iso;
                network = vm3.network;
            }
        ];
    };
}