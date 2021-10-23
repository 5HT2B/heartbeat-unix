# heartbeat-unix

This is the Linux / macOS / Unix client for Heartbeat. It will ping the central server every minute, as long as an input device (keyboard or mouse) has been used in the last two minutes, and your device is unlocked.

Do note, that checking for a screen lock only works on KDE's `kscreenlocker`. If you are on a different DE / screenlocker, feel free to make a pull request adding support for that DE / screenlocker.

## Usage

1. Download the ping script (POSIX compatible)

Download [`ping.sh`](https://github.com/technically-functional/heartbeat-unix/blob/master/ping.sh) anywhere you'd like, preferably like so
```bash
mkdir -p ~/.local/bin/
curl https://raw.githubusercontent.com/technically-functional/heartbeat-unix/master/ping.sh -o ~/.local/bin/ping.sh
chmod +x ~/.local/bin/ping.sh
```

Feel free to modify this however you'd like. Do note, **you *will* have to update the systemd service files** if you download it to a different location.

2. Setup config

Next, inside `~/.env`, add the following
```bash
export HEARTBEAT_AUTH='your heartbeat server token'
export HEARTBEAT_HOSTNAME="https://your.heartbeat.domain"
export HEARTBEAT_LOG_FILE="$HOME/.cache/heartbeat.log"
export HEARTBEAT_DEVICE_NAME="laptop"
```

3. Download and install the systemd service

If you are not using systemd on your system, please use the equivalent service for your system. Do **not** use a cronjob, as that does not work with `xprintidle` (required by the script).

```bash
mkdir -p ~/.config/systemd/user/
curl https://raw.githubusercontent.com/technically-functional/heartbeat-unix/master/heartbeat-client.service -o ~/.config/systemd/user/heartbeat-client.service
curl https://raw.githubusercontent.com/technically-functional/heartbeat-unix/master/heartbeat-client.timer -o ~/.config/systemd/user/heartbeat-client.timer
# Enable the service and timer for the current user
systemctl --user enable --now heartbeat-client.timer
```

4. Ensure that the client is setup correctly

To be sure your script is working and got a response from the server, run the following commands (this makes debugging easier + faster, but you could also just watch your heartbeat server's website for an update).

```bash
. ~/.env
cd ~/.local/bin/
./ping.sh
cat "$HEARTBEAT_LOG_FILE"
# The output should look somewhat like the following
# 2021/09/23 17:28:07 - Running Heartbeat
# 1632432488
```

### For macOS Users
Since macOS do not have commands like `xprintidle` and `kscreenlocker`, I simply created a shell script and a plist that will ping the heartbeat server every minute.

1. Move `heatbeat-client-macOS.sh` to a place where you like. I put it in `$HOME/.local/bin`.
2. Adjust `in.l1v.heartbeat.plist`.
3. Copy `in.l1v.heatbeat.plist` to `~/Library/LaunchAgents`.
4. Run `launchctl load ~/Library/LaunchAgents/in.l1v.heartbeat.plist`.
