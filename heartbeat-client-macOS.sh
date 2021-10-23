#!/usr/bin/env bash

# Update env variables if stored in file
if [[ -f "$HOME/.heartbeat" ]]; then
    chmod +x "$HOME/.heartbeat"
    . "$HOME/.heartbeat"
fi

if [ -z "$HEARTBEAT_AUTH" ] || [ -z "$HEARTBEAT_DEVICE_NAME" ] || [ -z "$HEARTBEAT_HOSTNAME" ]; then
  echo "Environment variables not setup correctly!"
  echo "HEARTBEAT_AUTH: $HEARTBEAT_AUTH"
  echo "HEARTBEAT_DEVICE_NAME:   $HEARTBEAT_HOSTNAME"
  echo "HEARTBEAT_HOSTNAME: $HEARTBEAT_HOSTNAME"
  exit
else
  echo "$(date +"%Y/%m/%d %T") - Running Heartbeat"
  curl -s -X POST -H "Auth: $HEARTBEAT_AUTH" -H "Device: $HEARTBEAT_DEVICE_NAME" "$HEARTBEAT_HOSTNAME/api/beat"
fi



