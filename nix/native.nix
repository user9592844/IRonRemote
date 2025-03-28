{ pkgs, fenix, crane }:
let
  bareMetalArch = with pkgs.stdenv;
    if hostPlatform.isx86_64 then
      "x86_64-unknown-none"
    else if hostPlatform.isAarch64 then
      "aarch64-unknown-none"
    else
      "unknown";
  rustToolchain = with fenix;
    combine [
      stable.cargo
      stable.clippy
      stable.rust-src
      stable.rustfmt
      stable.rust-analyzer
      targets."${bareMetalArch}".stable.rust-std
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

  CARGO_BUILD_TARGET = "${bareMetalArch}";
}
