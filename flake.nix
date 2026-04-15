{
  description = "Vanilla nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nixpkgs,
      nixvim,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          pkgs = import nixpkgs { inherit system; };

          vanillaNixvimModule = {
            inherit system;
            module = import ./default.nix { inherit pkgs; };
            extraSpecialArgs = { };
          };
        in
        {
          checks = {
            vanilla-nixvim = nixvimLib.check.mkTestDerivationFromNixvimModule vanillaNixvimModule;
          };

          packages = {
            # nix run .#vanilla-nixvim
            vanilla-nixvim = nixvim'.makeNixvimWithModule vanillaNixvimModule;
          };
        };
    }
    // {
      # Expose the nixvim module for consumption by downstream flakes.
      # Usage: imports = [ vanilla-nixvim.nixvimModules.vanilla-nixvim { inherit pkgs; } ];
      nixvimModules.vanilla-nixvim = import ./default.nix;
    };
}
