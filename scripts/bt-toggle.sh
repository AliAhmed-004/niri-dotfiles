#!/bin/bash

# Get default sink ID
DEFAULT_ID=$(wpctl status | awk '/Default Sink:/ {print $3}')

# Prepare sinks list and clean up volume info
SINKS=$(wpctl status |
  awk '/Sinks:/,/Sources:/ {if($0 ~ /[0-9]+\..*\[vol:/) {gsub(/[│*]/,""); print $1 " " substr($0,index($0,$3))}}' |
  sed 's/\[vol:.*\]//') # remove [vol: ...]

# Find the row number of the current default sink for rofi
ROW=0
i=0
while read -r line; do
  ID=$(echo "$line" | awk '{print $1}')
  if [[ "$ID" == "$DEFAULT_ID" ]]; then
    ROW=$i
    break
  fi
  ((i++))
done <<<"$SINKS"

# Show rofi menu with the current sink highlighted
SELECTED=$(echo "$SINKS" | rofi -dmenu -i -p "Select audio sink:" -selected-row "$ROW")

# Extract ID
SINK_ID=$(echo "$SELECTED" | awk '{print $1}')

# Set default sink and send notification
if [[ -n "$SINK_ID" ]]; then
  wpctl set-default "$SINK_ID"
  NAME=$(echo "$SELECTED" | cut -d' ' -f2- | sed 's/\[vol:.*\]//') # remove volume again just in case
  notify-send -t 2000 "Audio switched to $NAME 🎧"
fi
