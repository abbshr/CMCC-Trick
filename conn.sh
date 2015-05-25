#!/bin/bash

while true; do
  echo "try to connect to $1 ..."
  nmcli dev wifi connect $1 iface wlan0
  sleep 15s
  nmcli dev disconnect iface wlan0
done
