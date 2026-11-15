#!/bin/bash
# pack_train.sh: pack the training code (pysrc, training_recipes), its pinned dependencies and
# the starting checkpoint into runs/upload/train.tar.gz for the GPU machine. Runs locally.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Pack the training code and the starting checkpoint for the GPU pod.
set -euo pipefail
R=$(cd "$(dirname "$0")/../.." && pwd)
mkdir -p "$R/runs/upload"
tar czf "$R/runs/upload/train.tar.gz" -C "$R/cmix-T-dwc" \
    pysrc training_recipes pyproject.toml uv.lock models/6m-q4.tch
ls -la "$R/runs/upload/train.tar.gz"
