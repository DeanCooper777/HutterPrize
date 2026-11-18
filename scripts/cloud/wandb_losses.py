# wandb_losses.py: print the training loss at fixed steps from offline Weights & Biases logs,
# to compare the loss curves of training runs without uploading anything.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Print the logged training loss of offline wandb runs at the given steps.
#   python wandb_losses.py RUN_DIR [RUN_DIR ...]
# (RUN_DIR = wandb/offline-run-*; reads the .wandb protobuf log directly)
import glob
import json
import sys

from wandb.proto import wandb_internal_pb2
from wandb.sdk.internal import datastore

STEPS = [1, 2, 5, 10, 20, 50, 100, 150, 180, 300, 600, 1000, 1500, 1800]

for run_dir in sys.argv[1:]:
    path = glob.glob(f"{run_dir}/*.wandb")[0]
    ds = datastore.DataStore()
    ds.open_for_scan(path)
    rows = []
    while True:
        data = ds.scan_data()
        if data is None:
            break
        record = wandb_internal_pb2.Record()
        record.ParseFromString(data)
        if record.WhichOneof("record_type") == "history":
            row = {item.key or "/".join(item.nested_key): json.loads(item.value_json) for item in record.history.item}
            rows.append(row)
    loss_key = "train/loss"
    print(f"{run_dir}: {len(rows)} rows, key {loss_key}")
    for s in STEPS:
        if s <= len(rows) and loss_key in rows[s - 1]:
            print(f"  step {s:5d}: {rows[s - 1][loss_key]:.6f}")
