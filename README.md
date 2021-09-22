# heartbeat-unix

This is the Linux / macOS / Unix client for Heartbeat. It will ping the central server every minute, as long as an input device (keyboard or mouse) has been used in the last two minutes, and your device is unlocked.

Do note, that checking for a screen lock only works on KDE's `kscreenlocker`. If you are on a different DE / screenlocker, feel free to make a pull request adding support for that DE / screenlocker.

## Usage

Download [`ping.sh`](https://github.com/technically-functional/heartbeat-unix/blob/master/ping.sh) anywhere you'd like, preferably like so
```bash
mkdir -p ~/.local/bin/
wget -O ~/.local/bin/ping.sh https://github.com/technically-functional/heartbeat-unix/raw/master/ping.sh
chmod +X ~/.local/bin/ping.sh
```

Feel free to modify this however you'd like. 

Next, inside `~/.env`, add the following
```bash
export HEARTBEAT_AUTH='your heartbeat server token'
export HEARTBEAT_HOSTNAME="https://your.heartbeat.domain"
export HEARTBEAT_LOG_FILE="$HOME/.cache/heartbeat.log"
```

Next you want to add a cronjob to run this script every minute (or whenever you choose).
```
# run the 'crontab -e' command to open the editor, and add
* * * * * /home/your-username/.local/bin/ping.sh
```

And then you're finished. Feel free to tweak it or move the files around, just make sure you update the file the cronjob is pointing to.
