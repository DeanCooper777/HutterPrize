#!/bin/bash
# sw_boot.sh: bring a fresh GPU machine (volume at /workspace) to the state the sweep needs:
# both training trees, the slices named on the command line, and the queue runner.
#   sw_boot.sh "A64 196000000 64000000" ...     then append lines to /root/queue.txt
# Testing tool for rented cloud machines; not part of the submitted programs.
set -eu
W=/workspace
bash $W/sweep/sw_setup.sh tree
rm -rf /root/swp; mkdir -p /root/swp; cp -r /root/sw/pysrc /root/sw/training_recipes /root/swp/
cp $W/sweep/p/patch.py /root/swp/pysrc/; cp $W/sweep/p/sweep.py /root/swp/training_recipes/
(cd /root/swp && PYTHONPATH=. $W/train/.venv/bin/python -m pysrc.patch /root/swp/pysrc/model.py 2>&1 | grep -a hook)
for c in "$@"; do set -- $c; python3 $W/sweep/sw_cut.py $1 $2 $3 $W/data /root/slices; done
touch /root/queue.txt; cp $W/sweep/p/sw_sched.sh /root/sw_sched.sh
cd /root; setsid nohup bash /root/sw_sched.sh > /root/sched.log 2>&1 < /dev/null &
echo boot ok
