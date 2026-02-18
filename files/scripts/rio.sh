#!/usr/bin/env -S guix shell plan9port -- sh

# Start Xephyr
echo "Starting Xephyr..."
Xephyr -br -ac -noreset -screen 1280x720 :9956 &>/dev/null &

# Set Display for Rio
export DISPLAY=:9956

# Wait for Xephyr, then Start Rio
sleep 1
echo "Starting Rio..."
9 rio &
echo "Setting Wallpaper..."
feh --bg-fill ~/Pictures/Wallpapers/guix_wp_02.png

export rioPid=$(pidof rio)
echo "Waiting for Rio to die..."
wait $rioPid

# Kill Leftover Xephyr's
if pgrep -x Xephyr || pgrep -x xephyr; then
    echo "Attempting to kill Xephyr..."
    pkill Xephyr
    pkill xephyr
    echo "Killed Xephyr"
else
    echo "Xephyr already dead."
fi
