{ pkgs, fenix }:
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

  cargoUtilities = with pkgs; [
    cargo-audit
    cargo-edit
    cargo-expand
    cargo-nextest
    cargo-udeps
  ];

  developerTools = with pkgs; [
    bat
    blflash
    fd
    helix
    hexyl
    lldb
    lsd
    openocd
    renode
    ripgrep
    uutils-coreutils
  ];
in pkgs.mkShell {
  packages = [ cargoUtilities developerTools ];

  nativeBuildInputs = [ rustToolchain ];
}
