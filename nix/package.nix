{ pkgs, fenix, crane }:
let
  rustToolchain = with fenix;
    combine [
      stable.cargo
      stable.clippy
      stable.rust-src
      stable.rustfmt
      stable.rust-analyzer
      targets.riscv32imafc-unknown-none-elf.stable.rust-std
    ];
  craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;
  src = craneLib.cleanCargoSource ../.;
in craneLib.buildPackage {
  inherit src;
  strictDeps = true;

  doCheck = false;

  cargoVendorDir = craneLib.vendorMultipleCargoDeps {
    inherit (craneLib.findCargoFiles src) cargoConfigs;
    cargoLockList = [ ../Cargo.lock ];
  };

  CARGO_BUILD_TARGET = "riscv32imafc-unknown-none-elf";
  MEMORY_X_FILE = toString ../memory.x;
}
