# comma C3/C3X GPT recovery tool

A tool for recovering from GPT issues on comma C3 and comma C3X. This tool includes a safety check to prevent accidental flashing on incompatible devices.

If you tried flashing your device on https://flash.comma.ai and got an error about GPTs (e.g. "Flashing error Both primary and backup gpt headers are corrupted, cannot recover"), you can use this tool to recover the GPTs.

## Supported Devices

- comma C3 (64GB)
- comma C3X (128GB)

> **Note**: This tool does NOT work with C2 or other devices!

## Prerequisites

- Python 3.x
- Device in QDL mode (check QDL Mode on https://flash.comma.ai)

### For M-series Macs

On M-series macs, if you get "No backend available" where python is installed with `pyenv` and `libusb` with `brew`, try this:

```
brew install libusb
sudo mkdir -p /usr/local/lib
sudo ln -s /opt/homebrew/lib/libusb-1.0.0.dylib /usr/local/lib/libusb.dylib
```

## Usage

1. Clone this repository or download it as a zip file and unzip it.

2. Run `./flash_gpts.sh`

3. The script will:
   - Set up the EDL tool automatically
   - Check device compatibility
   - Detect device type (C3/C3X)
   - Ask for confirmation before flashing
   - Flash the GPTs
   - Reboot the device
