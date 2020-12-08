#!/bin/bash

delay=${1}

if [[ ! -d /data/offload/reload ]]; then
  echo "/data/offload/reload/ doesn't exist"
  exit
fi

if [[ ! -d /data/offload/reload.bak ]]; then
  echo "/data/offload/reload.bak/ doesn't exist"
  exit
fi

#stat /data/offload/reload.bak/* >& /dev/null
#if $no_files; then
#  echo "No data to trickle"
#  exit
#fi

echo "Trickling at ${delay} seconds per file"

for file in /data/offload/reload.bak/*; do
  files_left=$(ls -1 /data/offload/reload.bak/* | wc -l)
  time_left=$(echo "${files_left}*${delay}" | bc | awk '{printf("%d",$1+0.5)}')
  eta="$(date +'%Y-%m-%d %H:%M:%S' -d "${time_left} second")"
  printf 'Moving %s, ETA %s, Time left %d:%02d\n' $(basename ${file}) "${eta}" $((${time_left}/60)) $((${time_left}%60))
  mv ${file} /data/offload/reload/
  sleep ${delay}
done

