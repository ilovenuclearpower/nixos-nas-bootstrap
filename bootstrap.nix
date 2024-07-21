{
  description = "A simple Flake to write environment variables";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux"; # Change this to your target system
    pkgs = nixpkgs.legacyPackages.${system};

    envVars = {
      VDEV_MAX = "7";
    };

    varsContent = let
      varList = builtins.mapAttrsToList (name: value: "${name}=${value}") envVars;
    in concatStringsSep "\n" varList;

    envFile = pkgs.writeTextFile {
      name = "env-vars.sh";
      text = varsContent;
      destination = "/etc/dyn/bootstrap_vars.txt"; # Adjust the path as needed
    };
  in
  {
}
