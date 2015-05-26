#!/bin/bash

clean_up() {
  echo "cleanning connection files ..."
  rm /etc/NetworkManager/system-connections/${1}*
  ref=0
}

bootstrap() {
  declare -i ref=$(ls -alsh /etc/NetworkManager/system-connections/ | grep ${ARG}* | wc -l)
  ((ref >= LIMIT)) && clean_up
}

declare -i LIMIT=10
TIMEOUT=15s
ARG=$1
bootstrap

while true; do
  echo "try to connect to $1 ..."
  nmcli dev wifi connect $1 iface wlan0
  case $? in
    0 )
      sleep 15s
      nmcli dev disconnect iface wlan0
    ;;
    1 )
      exit 1
    ;;
    4 )
      if ((ref >= LIMIT)); then
        clean_up $1
      else
        ref+=1
      fi
    ;;
  esac
done
