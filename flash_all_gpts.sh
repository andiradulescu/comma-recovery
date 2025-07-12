#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd $DIR

GPT_FOLDER="gpt/universal"
echo "Flashing GPTs from '$GPT_FOLDER'..."

for LUN in {0..5}; do
  edl w gpt "$DIR/$GPT_FOLDER/gpt_main$LUN.bin" --lun=$LUN
done