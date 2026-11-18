#!/bin/bash
# sw.sh: run a command or a local script on a rented machine over ssh, or copy files to it.
#   sw.sh HOST PORT run 'command'        sw.sh HOST PORT script local.sh [args]
#   sw.sh HOST PORT put local... remote_dir
# Testing tool for rented cloud machines; not part of the submitted programs.
H=$1; P=$2; M=$3; shift 3
O="-i $HOME/.ssh/runpod_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=20"
case $M in
  run) ssh $O -p $P root@$H "$*" < /dev/null ;;
  script) f=$1; shift; ssh $O -p $P root@$H "bash -s -- $*" < "$f" ;;
  put) n=$#; d=${!n}; scp $O -P $P "${@:1:$((n - 1))}" root@$H:$d ;;
esac
