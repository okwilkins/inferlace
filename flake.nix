{
  description = "One model inference engine written by hand for a RTX 4080 Lovelace GPU architecture";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            python314
            uv
            ruff
            ty

            cudaPackages.cudatoolkit
            cudaPackages.cuda_cudart
          ];
          shellHook = ''
            export CUDA_HOME="${pkgs.cudaPackages.cudatoolkit}"
            export LD_LIBRARY_PATH=/run/opengl-driver/lib:${pkgs.libglvnd}/lib:${
              pkgs.lib.makeLibraryPath [
                pkgs.cudatoolkit
                pkgs.cudaPackages.cuda_cudart
                pkgs.stdenv.cc.cc.lib
              ]
            }:$LD_LIBRARY_PATH
          '';
        };
      }
    );
}
