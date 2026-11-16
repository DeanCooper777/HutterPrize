#!/bin/bash
# sw_sched.sh: launch queued sweep points on one large GPU as memory frees up.
# Queue file /root/queue.txt, one point per line (lines can be appended while it runs):
#   NAME SLICE LAYERS DMODEL HEADS DMLP EPOCHS PATCH MEM_GB
# A point starts when free GPU memory minus the memory reserved for points started in the
# last 15 minutes (they may not have allocated yet) is at least MEM_GB + 6.
# Testing tool for rented cloud machines; not part of the submitted programs.
Q=/root/queue.txt; D=/root/sched; mkdir -p $D; touch $D/started
while true; do
  while read name slice l d h m ep patch mem; do
    [ -z "$name" ] && continue
    grep -q "^$name " $D/started && continue
    [ -s /workspace/sweep/out/$name.json ] && { echo "$name 0 0" >> $D/started; continue; }
    free=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits | head -n 1); free=$((free / 1024))
    now=$(date +%s); res=0
    while read n t g; do [ $((now - t)) -lt 900 ] && res=$((res + g)); done < $D/started
    [ $(pgrep -f -c [t]raining_recipes.sweep) -ge 14 ] && break
    if [ $((free - res)) -ge $((mem + 6)) ]; then
      echo "$name $slice $l $d $h $m $ep" > /root/l_$name.txt
      SW_TREE=/root/swp S_PATCH=$patch OMP_NUM_THREADS=2 setsid nohup bash /workspace/sweep/p/sw_run2.sh /root/l_$name.txt > /root/run_$name.log 2>&1 < /dev/null &
      echo "$name $now $mem" >> $D/started
      echo "$(date -u +%H:%M:%S) started $name (free $free GB, reserved $res GB)"
    else
      break   # keep the queue order
    fi
  done < $Q
  sleep 60
done
