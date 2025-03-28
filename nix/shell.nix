{ pkgs, fenix }:
let
  rustToolchain = with fenix;
    combine [
      stable.cargo
      stable.clippy
      stable.rust-src
      stable.rustfmt
      stable.rust-analyzer
      stable.llvm-tools-preview

      targets.riscv32imafc-unknown-none-elf.stable.rust-std
    ];

  cargoUtilities = with pkgs; [
    cargo-audit
    cargo-binutils
    cargo-edit
    cargo-expand
    cargo-nextest
    cargo-udeps
  ];

  developerTools = with pkgs; [
    bat
    binwalk
    blflash
    fd
    gdb
    helix
    hexyl
    lsd
    minicom
    openocd
    renode
    ripgrep
    uutils-coreutils
  ];

  libUtils = with pkgs; [ libftdi ];

  fdt = pkgs.callPackage ./fdt.nix { buildPythonPackage = pkgs.python3Packages.buildPythonPackage; fetchPypi = pkgs.python3Packages.fetchPypi;  };

  python3WithLibs = pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
    fdt
    pycryptodomex
    toml
    configobj
  ]);
in pkgs.mkShell {
  packages = [ cargoUtilities developerTools libUtils python3WithLibs ];

  nativeBuildInputs = [ rustToolchain ];
}
