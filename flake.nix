{
  description = "A flake for building monitor-tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
       packages.${system} = {
        monitor-daemon = pkgs.writeShellApplication {
          name = "monitor-daemon";

          runtimeInputs = with pkgs; [
            bash
            coreutils
            util-linux
            udev
            jq
          ];

          text = builtins.readFile ./monitor-daemon/main.sh;
        };

        monitor-query = pkgs.writeShellApplication {
          name = "monitor-query";

          runtimeInputs = with pkgs; [
            bash
            coreutils
            util-linux
            jq
            edid-decode
          ];

          text = builtins.readFile ./monitor-query/main.sh;
        };

        default = self.packages.${system}.monitor-daemon;
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Native libs (runtime parity)
          udev
          systemd
          dbus

          coreutils
          util-linux
          jq
          shellcheck

          # New
          nushell
          edid-decode
        ];
      };
    };
}
