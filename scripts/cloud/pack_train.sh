#!/bin/bash
# Pack the training code and the starting checkpoint for the GPU pod.
set -euo pipefail
R=$(cd "$(dirname "$0")/../.." && pwd)
mkdir -p "$R/runs/upload"
tar czf "$R/runs/upload/train.tar.gz" -C "$R/fx2-cmix-T" \
    pysrc training_recipes pyproject.toml uv.lock models/6m-q4.tch
ls -la "$R/runs/upload/train.tar.gz"
