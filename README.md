# Q2 Fix

A simple script to free up system resources on the Qidi Q2 by disabling unnecessary background services.

## How to SSH Into Your Printer

1. Open your terminal:
   - **Windows:** Open **Command Prompt** (`cmd`) or PowerShell.
   - **macOS / Linux:** Open your preferred **Terminal** app.
2. Connect to your printer's IP address by running:
   ```bash
   ssh mks@YOUR_PRINTER_IP
   ```
   *(Replace `YOUR_PRINTER_IP` with the actual IP address of your Qidi Q2).*
3. When prompted for a password, enter:
   ```text
   makerbase
   ```

## Usage

Once you are SSH'd into your printer, run the following one-line command:

```bash
bash <(curl -s [https://raw.githubusercontent.com/kanrog/Q2_fix/main/fix.sh](https://raw.githubusercontent.com/kanrog/Q2_fix/main/fix.sh))
```

After running the script, restart your printer for the best results.


## What It Does

This script runs the following commands automatically to stop and disable unused services:

```bash
sudo systemctl stop QIDILink-client.service && sudo systemctl disable QIDILink-client.service
sudo systemctl stop strongswan-starter.service && sudo systemctl disable strongswan-starter.service
sudo systemctl stop "bluetoothtd.service  NO" && sudo systemctl disable "bluetoothtd.service  NO"
sudo systemctl stop "pulseaudio.service  NO" && sudo systemctl disable "pulseaudio.service  NO"
sudo systemctl stop xl2tpd.service && sudo systemctl disable xl2tpd.service
sudo systemctl stop triggerhappy.service && sudo systemctl disable triggerhappy.service
sudo systemctl stop openvpn.service && sudo systemctl disable openvpn.service
sudo systemctl stop lightdm.service && sudo systemctl disable lightdm.service
sudo systemctl stop algo_app.service && sudo systemctl disable algo_app.service
```