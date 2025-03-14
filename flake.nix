{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };


        # libraries = with pkgs; [
        #   libpng
        #   zlib
        # ];
        #
        # # These are mostly needed for raylib to build
        # packages = with pkgs; [
        #   cmake
        #   pkg-config 
        # ] ++ pkgs.lib.lists.optionals stdenv.isLinux [
        #     # [NixOS package requirements](https://github.com/pret/pokeemerald/blob/master/INSTALL.md#nixos)
        #     pkgsCross.arm-embedded.stdenv.cc 
        #     # git # Idk why git is needed
        #     pkg-config 
        # ] ++ pkgs.lib.lists.optionals stdenv.isDarwin [
        #   # [Raylib]
        #   # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/apple-sdk/frameworks.nix
        #   # darwin.apple_sdk.frameworks.Cocoa
        #   # darwin.apple_sdk.frameworks.Kernel
        # ];

        # Inputs needed at compile-time
      in
      {
        # packages.default = naerskLib.buildPackage {
        #    src = ./.;
        # };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            cmake
            llvmPackages_19.clang-tools
          ];

          buildInputs = with pkgs; [
            zlib
            libpng
          ];

          shellHook = with pkgs; ''
          '' + lib.optionalString stdenv.isDarwin ''
          export DEVKITPRO="/opt/devkitpro";
          export DEVKITARM="$DEVKITPRO/devkitARM";
          '';
          #export PATH="/Library/Developer/CommandLineTools/usr/bin:$PATH";
          #export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH"
          #export LD_DYLD_PATH="${pkgs.lib.makeLibraryPath libraries}:$LD_DYLD_PATH"
        };
      });
}
