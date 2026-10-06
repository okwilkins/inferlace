{
  description = "One model inference engine written by hand for RTX 4080 Lovelace GPU architecture";
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

        download-model = pkgs.writeShellApplication {
          name = "download-model";
          runtimeInputs = [ pkgs.python3Packages.huggingface-hub ];
          text = ''
            mkdir -p models/Qwen3.5-9B
            exec hf download \
              lovedheart/Qwen3.5-9B-FP8 \
              --revision 5d77dcb2e2c606bc261b5b8e946a67781f18d733 \
              --local-dir models/Qwen3.5-9B-FP8 \
              "$@"
          '';
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

            download-model
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
