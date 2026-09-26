# Inferlace

Inferlace is a handwritten, dare I say *artisan*, inference engine made to, by my best abilities, maximise my Ada Lovelace RTX 4080 GPU.

My goals here are to:
1. *Have fun!*
2. Learn ***how*** and ***why*** inference engines like [vLLM](https://vllm.ai/) implement its features.
3. Further develop skills in:
    - C++
    - CUDA
    - PyTorch
    - GPU profiling
    - LLM internals

## Getting Started

### Enter the Dev Shell

All tools (Python 3.14, uv, ruff, ty) come from Nix.

```bash
nix develop --command $SHELL
```

### Sync the Project

```bash
uv sync
```

This creates `.venv` and installs the project (editable).

