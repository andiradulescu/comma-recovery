#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd $DIR

echo "------------------------------"
echo "comma C3/C3X GPT recovery tool"
echo "------------------------------"

# source edl wrapper and run compatibility check
source tools/edl.sh
source tools/check_device_compatibility.sh

# backup persist partition before flashing
echo "Automatically backing up persist partition to persist.img..."
edl r persist persist.img
if [ ! -s persist.img ]; then
  echo "Error: Failed to backup persist partition."
  exit 1
fi

echo "If your device was in slot B, it will be switched to slot A after flashing."
read -p "Press Enter to begin flashing or Ctrl+C to cancel..."

GPT_FOLDER="gpt/$DEVICE_TYPE"
echo "Flashing GPTs from '$GPT_FOLDER'..."

# flash GPTs for Lun 0, 1, 2, 4 (Lun 3 and 5 don't have slots)
edl w gpt "$DIR/$GPT_FOLDER/gpt_main0.bin" --lun=0
edl w gpt "$DIR/$GPT_FOLDER/gpt_main1.bin" --lun=1
edl w gpt "$DIR/$GPT_FOLDER/gpt_main2.bin" --lun=2
edl w gpt "$DIR/$GPT_FOLDER/gpt_main4.bin" --lun=4

# set bootable storage drive to slot 1 (slot a)
edl setbootablestoragedrive 1

# reset device
edl reset

echo "GPT flashing completed!"
