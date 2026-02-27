#!/usr/bin/env bash

if alias 9 &>/dev/null; then unalias 9; fi

nineBin=$(ls -l $(which 9) | awk '{print $11}')
plan9BinsPath=$(ls -l $(which 9) | awk '{print $11}' | sed 's|/bin/9|/plan9/bin|g')

NINEHOME=/tmp/Plan9
if [[ ! -d "$NINEHOME" ]]; then mkdir -p $NINEHOME; fi

cd "$NINEHOME"

NINEDISPLAY=:9956
NINESHELL="${plan9BinsPath}/rc"
NINETERM="${nineBin} 9term ${NINESHELL}"
NINEEDITOR="${plan9BinsPath}/acme"

EDITOR=${NINEEDITOR} HOME=${NINEHOME} SHELL=${SHELL} TERM=${TERM} Xephyr -br -ac -noreset -screen 1920x1080 ${NINEDISPLAY} &>/dev/null &
xephyrPid=$!

until xset -display ${NINEDISPLAY} q > /dev/null 2>&1; do
    sleep 0.1
done

EDITOR="$NINEEDITOR" HOME="$NINEHOME" SHELL="$NINESHELL" TERM="$NINETERM" DISPLAY="$NINEDISPLAY" exec ${nineBin} ${plan9BinsPath}/rio &>/dev/null &
rioPid=$!

echo "EDITOR=${NINEEDITOR} HOME=${NINEHOME} SHELL=${NINESHELL} TERM=${NINETERM} DISPLAY=${NINEDISPLAY} &>/dev/null &"

wait $xephyrPid
exit 0
