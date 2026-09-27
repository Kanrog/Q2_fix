# Q2 Fix

A collection of scripts to optimize system resources and update configurations on the Qidi Q2 printer.

> **Credits:** Original lists and fixes provided by **MI3**.

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

---

## Script 1: System Services Optimizer (`fix.sh`)

A simple script to free up system resources on the Qidi Q2 by disabling unnecessary background services.

### Usage

Once you are SSH'd into your printer, run the following one-line command:

```bash
bash <(curl -s https://raw.githubusercontent.com/kanrog/Q2_fix/main/fix.sh)
```

After running the script, restart your printer for the best results.

### What It Does

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

---

## Script 2: Configuration Optimizer (`cfg_fix.sh`)

This script uses a hybrid approach to update your printer configurations safely:
1. **New Additions:** Creates a separate `custom.cfg` file containing the `Host_CPU` and `toolhead` temperature sensors and automatically adds `[include custom.cfg]` to your main configuration.
2. **Direct Edits:** Updates existing blocks (`[tmc2209 extruder]`, `[heater_generic chamber]`, `[controller_fan board_fan]`, and `[tmc2240 stepper_x/y]` slope control) directly in `printer.cfg`. It automatically generates a safety backup named `printer.cfg.bak` before making changes.

### Usage
Once SSH'd into your printer, run:
```bash
bash <(curl -s https://raw.githubusercontent.com/kanrog/Q2_fix/main/fix.sh)
```

---

## How to Undo / Rollback Configuration Changes

If you ever need to revert the configuration changes made by `cfg_fix.sh`, you can do it manually via SSH in a few simple steps:

### 1. Restore the Original `printer.cfg` Backup
The script automatically backs up your original file before touching it. You can restore it instantly by running:
```bash
cp ~/printer_data/config/printer.cfg.bak ~/printer_data/config/printer.cfg
```
*(Note: Adjust the path if your configuration directory differs).*

### 2. Remove the `custom.cfg` File
To completely get rid of the custom sensors file, delete it from your config directory:
```bash
rm ~/printer_data/config/custom.cfg
```

After doing either step, remember to restart Klipper or reboot your printer for the stock state to reload.