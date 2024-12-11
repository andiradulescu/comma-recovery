#!/usr/bin/env bash
set -e

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

# just a nice wrapper around the edl python tool
# https://github.com/commaai/agnos-builder/blob/master/tools/edl

EDL_PATH=$TOOLS_DIR/edl_repo
VERSION="8573eba1b576305fec3a068393283143ffc34342"

if [ ! -d "$EDL_PATH" ]; then
  echo "Setting up edl..."
  tput setaf 8 # set text color to gray
  rm -rf $EDL_PATH
  git clone https://github.com/bkerler/edl $EDL_PATH
  tput sgr0    # reset text color to default
fi

pushd $EDL_PATH > /dev/null

if command -v python3 &>/dev/null; then
  PYTHON_CMD=python3
elif command -v python &>/dev/null; then
  PYTHON_CMD=python
else
  echo "Error: Python not found"
  exit 1
fi

$PYTHON_CMD -m venv venv

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

if [ "$(< .git/HEAD)" != "$VERSION" ]; then
  echo "Updating edl..."
  tput setaf 8 # set text color to gray
  git fetch origin $VERSION
  git checkout $VERSION
  git submodule update --depth=1 --init --recursive
  pip3 install -r requirements.txt
  tput sgr0    # reset text color to default
fi

popd > /dev/null

edl() {
  tput setaf 8 # set text color to gray
  $PYTHON_CMD $EDL_PATH/edl "$@"
  tput sgr0    # reset text color to default
}
