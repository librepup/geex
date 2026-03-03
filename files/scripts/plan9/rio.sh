#!/usr/bin/env -S guix shell plan9port -- bash

unalias -m 9

export NINEBIN=$(ls -la $(which 9) | awk '{print $11}' | sed "s/\/bin\/9/\/plan9\/bin/g")
export TERMBIN="${NINEBIN}/9term"
export SHELLBIN="${NINEBIN}/rc"

export TERM=$TERMBIN
export SHELL=$SHELLBIN

# Start Xephyr
echo "Starting Xephyr..."
Xephyr -br -ac -noreset -screen 1920x1080 :9956 &>/dev/null &

# Set Display for Rio
export DISPLAY=:9956

# Wait for Xephyr, then Start Rio
sleep 1
echo "Starting Rio..."
9 rio &
#echo "Setting Wallpaper..."
#feh --bg-fill ~/Pictures/Wallpapers/dangeroooous_jungle_wp.png &
9 stats -W 640x120 -E -l -m -s &

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
