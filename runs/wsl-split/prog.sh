for t in st2 c2; do printf "$t: "; tr '\r' '\n' < /root/split/$t/c15/log | grep -v '^ *$' | tail -1 | cut -c1-120; done; ps -eo etime,args | grep '[c]mix -n' | cut -c1-30
