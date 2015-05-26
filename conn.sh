#!/bin/bash

clean_up() {
  rm /etc/NetworkManager/system-connections/${1}*
  ref=0
}

bootstrap() {
  declare -i ref=$(ll /etc/NetworkManager/system-connections/ | grep ${1}* | wc -l)
  ((ref >= LIMIT)) && clean_up
}

declare -i LIMIT=10
TIMEOUT=15s
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
      if ((ref >= LIMIT)) then
        echo "cleanning connection files ..."
        clean_up $1
      else
        ref+=1
      fi
    ;;
  esac
done
