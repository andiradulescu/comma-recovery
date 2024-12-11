#!/bin/bash

echo "Checking device compatibility..."
current_printgpt=$(edl printgpt 2>/dev/null)

if [ -z "$current_printgpt" ]; then
  echo "Error: Could not read device GPT. Make sure device is connected in QDL mode."
  exit 1
fi

# detect device type
if [[ "$current_printgpt" =~ "Total disk size:0x0000001c65800000, sectors:0x0000000001c65800" ]]; then
  echo "Detected: comma C3X (128GB)"
  DEVICE_TYPE="c3x"
elif [[ "$current_printgpt" =~ "Total disk size:0x0000000d7d800000, sectors:0x0000000000d7d800" ]]; then
  echo "Detected: comma C3 (64GB)"
  DEVICE_TYPE="c3"
else
  echo "Error: Device doesn't seem to be a comma C3 or comma 3X."
  echo "If you think this is incorrect, run './printgpt.sh' and open an issue on GitHub with the output."
  exit 1
fi
