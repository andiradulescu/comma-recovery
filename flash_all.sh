#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd $DIR

# source edl wrapper and run compatibility check
source tools/edl.sh

./download-from-manifest.py

for LUN in {0..5}; do
  edl w gpt "$DIR/output/gpt_main_$LUN.img" --lun=$LUN
done

for part in abl aop devcfg xbl xbl_config boot system; do
  edl w ${part}_a $DIR/output/$part.img
  edl w ${part}_b $DIR/output/$part.img
done

for fw_file in "$DIR/output/"*; do

  if [[ "$fw_file" == *abl* || "$fw_file" == *aop* || "$fw_file" == *devcfg* || "$fw_file" == *xbl* || "$fw_file" == *xbl_config* || "$fw_file" == *boot* || "$fw_file" == *system* || "$fw_file" == *gpt* ]]; then
    continue
  fi

  if [ -f "$fw_file" ]; then
    fw_name=$(basename "$fw_file")
    fw_name_no_ext="${fw_name%.*}"
    echo "Flashing $fw_name_no_ext $fw_file"
    edl w "$fw_name_no_ext" "$fw_file"
  fi
done

edl setbootablestoragedrive 1
