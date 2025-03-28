{
  description =
    "An infrared remote with thermistor for controlling an aircon split-system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix.url = "github:nix-community/fenix";
    # naersk.url = "github:nix-community/naersk";
    crane.url = "github:ipetkov/crane";
  };

  outputs = { self, nixpkgs, fenix, crane }:
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      forEachSupportedSystem = nixpkgs.lib.genAttrs supportedSystems;
    in {
      # nix develop
      devShells = forEachSupportedSystem (system:
        let
          pkgs = import nixpkgs {
            system = "${system}";
            config = { allowUnfree = true; };
          };
        in {
          default = pkgs.callPackage ./nix/shell.nix {
            fenix = fenix.packages."${system}";
          };
        });

      # nix build
      packages = forEachSupportedSystem (system:
        let
          pkgs = import nixpkgs {
            system = "${system}";
            config = { allowUnfree = true; };
          };
        in {
          native = pkgs.callPackage ./nix/native.nix {
            inherit crane;
            fenix = fenix.packages."${system}";
          };
          default = pkgs.callPackage ./nix/package.nix {
            inherit crane;
            fenix = fenix.packages."${system}";
          };
        });
    };
}
