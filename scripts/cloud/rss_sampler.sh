# laptop session: sample the compressor's memory/cpu/io once a minute (local disk only)
while true; do
  for p in $(pgrep -x cmix) $(pgrep -x archive9); do
    echo "$(date -u +%F_%T) pid $p $(grep -E 'VmHWM|VmRSS|RssAnon|RssFile' /proc/$p/status | tr -s '\t \n' ' ') cpu_ticks $(awk '{print $14+$15, "stime", $15, "minflt", $10}' /proc/$p/stat) $(grep ^write_bytes /proc/$p/io)" >> /root/rss.log
  done
  sleep 60
done
