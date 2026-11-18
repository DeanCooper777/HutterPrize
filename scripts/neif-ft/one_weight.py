#!/usr/bin/env python3
# one_weight.py: testing tool (not part of any submitted program).
#
#   one_weight.py <shipped NP2> <out v5>
#
# Negative test of the fingerprint override: reads the shipped container, changes ONE integer weight
# (blocks.8.mlp.down.weight.q, the first element with value 1 becomes 2) and writes the tensors as a
# plain v5 container; the authors' NP2 writer then makes a valid NP2 container of it that differs from
# the shipped one in one weight (and in the neuron order the format derives from the coded bytes).
import os
import sys

import numpy as np

NEIF2 = os.environ.get("NEIF2", "/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev")
sys.path.insert(0, os.path.join(NEIF2, "training", "tf", "3_train", "export", "np2"))
sys.dont_write_bytecode = True
import np2_container as npc  # noqa: E402

es = npc.read_container(sys.argv[1])
e = [x for x in es if x.name == "blocks.8.mlp.down.weight.q"][0]
flat = e.a.reshape(-1)
i = int(np.flatnonzero(flat == 1)[0])
flat[i] = 2
print("changed %s element %d of %d: 1 -> 2" % (e.name, i, flat.size))
open(sys.argv[2], "wb").write(npc.encode_plain(es, True))
print("wrote", sys.argv[2])
