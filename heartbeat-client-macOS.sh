#!/usr/bin/env bash

if ! [ -e "$HOME/.heartbeat" ]; then
    echo "$HOME/.heartbeat not setup, please create it"
    exit 1
fi

if [[ -z "$HEARTBEAT_AUTH" ]] || [[ -z "$HEARTBEAT_DEVICE_NAME" ]] || [[ -z "$HEARTBEAT_HOSTNAME" ]]; then
    echo "Environment variables not setup correctly!"
    echo "HEARTBEAT_AUTH: $HEARTBEAT_AUTH"
    echo "HEARTBEAT_DEVICE_NAME: $HEARTBEAT_HOSTNAME"
    echo "HEARTBEAT_HOSTNAME: $HEARTBEAT_HOSTNAME"
    exit 1
else
    # Check when the last HID event was sent
    LAST_INPUT_MS="$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/{print $NF}')"

    # Launchd will not execute the task if the system is locked or sleeping, so no need to worry about the screen lock state
    if [[ $LAST_INPUT_MS -lt 120000 ]]; then
        {
            echo "$(date +"%Y/%m/%d %T") - Running Heartbeat"
            curl -s -X POST -H "Auth: $HEARTBEAT_AUTH" -H "Device: $HEARTBEAT_DEVICE_NAME" "$HEARTBEAT_HOSTNAME/api/beat"
            echo ""
        } >> "$HEARTBEAT_LOG_FILE" 2>&1
    fi
fi
