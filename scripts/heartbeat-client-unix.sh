#!/usr/bin/env sh

if ! [ -e "$HOME/.env" ]; then
    echo "$HOME/.env not setup, please create it"
    exit 1
fi

# shellcheck disable=SC1091
. "$HOME/.env"

if [ -z "$HEARTBEAT_AUTH" ] || [ -z "$HEARTBEAT_LOG_DIR" ] || [ -z "$HEARTBEAT_HOSTNAME" ] || [ -z "$HEARTBEAT_DEVICE_NAME" ]; then
    echo "Environment variables not setup correctly!"
    echo "HEARTBEAT_AUTH: $HEARTBEAT_AUTH"
    echo "HEARTBEAT_LOG_DIR: $HEARTBEAT_LOG_DIR"
    echo "HEARTBEAT_HOSTNAME: $HEARTBEAT_HOSTNAME"
    echo "HEARTBEAT_DEVICE_NAME: $HEARTBEAT_DEVICE_NAME"
    exit 1
else
    if [ -z "$(which xprintidle)" ]; then
        echo "xprintidle not found, please install it!"
        exit 1
    fi

    # Check if kscreenlocker is running. Only works on KDE
    SCREEN_LOCKED="$(pgrep kscreenlocker)"
    # Check when the last keyboard or mouse event was sent
    LAST_INPUT_MS="$(xprintidle)"

    # Make sure the device was used in the last 2 minutes
    # and make sure screen is unlocked
    if [ "$LAST_INPUT_MS" -lt 120000 ] && [ -z "$SCREEN_LOCKED" ]; then
        {
            echo "$(date +"%Y/%m/%d %T") - Running Heartbeat"
            curl -s -X POST -H "Auth: $HEARTBEAT_AUTH" -H "Device: $HEARTBEAT_DEVICE_NAME" "$HEARTBEAT_HOSTNAME/api/beat"
            echo ""
        } >> "$HEARTBEAT_LOG_DIR/heartbeat.log" 2>&1
    fi
fi
