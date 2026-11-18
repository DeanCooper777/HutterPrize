#!/bin/bash
# waitfor.sh FILE PATTERN [SECONDS]: stay attached (keeps the WSL VM running) until PATTERN appears in FILE.
for i in $(seq 1 $(( ${3:-570} / 5 ))); do grep -q "$2" "$1" 2> /dev/null && break; sleep 5; done
date; tail -n 25 "$1" | cut -c1-200
