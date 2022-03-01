#!/usr/bin/env bash

attacks=("HTTP" "UDP" "NTP" "SYN" "POD" "ICMP" "Slowloris" "Memcached")

for attack in ${attacks[@]}; do
  tmux new-session -d -s "${attack}" "'./attack.sh --method ${attack} --time 50 --threads 20'"
done
