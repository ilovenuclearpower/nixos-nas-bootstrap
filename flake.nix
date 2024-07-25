{
  description = "My NixOS system configuration with Flakes";

  inputs.vscode-server.url = "github:nix-community/nixos-vscode-server";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, vscode-server }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix
        ./users.nix
        ./nfs.nix
        ./rsync.nix
        vscode-server.nixosModules.default
        ({ config, pkgs, ...}: {
          services.vscode-server.enable = true;
        })
      ];
    };
  };
}
