#!/bin/bash

# Qidi Q2 Hybrid Config Fix Script
# Credits: MI3

# Target the standard Klipper config directory explicitly to avoid backups
CONFIG_PATH=$(find ~/printer_data/config -maxdepth 1 -name "printer.cfg" 2>/dev/null | head -n 1)

if [ -z "$CONFIG_PATH" ]; then
    echo "Error: Could not find printer.cfg in ~/printer_data/config!"
    exit 1
fi

CONFIG_DIR=$(dirname "$CONFIG_PATH")
CUSTOM_PATH="$CONFIG_DIR/custom.cfg"

echo "Found active printer.cfg at: $CONFIG_PATH"

# 1. Create custom.cfg for pure additions
echo "Creating/updating custom.cfg..."
cat << 'EOF' > "$CUSTOM_PATH"
# --- Q2 Custom Additions (Sensors) ---
# Credits: MI3

[temperature_sensor Host_CPU]
sensor_type: temperature_host
min_temp: 10
max_temp: 100

[temperature_sensor toolhead]
sensor_type: temperature_mcu
sensor_mcu: THR
min_temp: 0
max_temp: 100
EOF

# 2. Ensure [include custom.cfg] is in printer.cfg
if grep -q "custom.cfg" "$CONFIG_PATH"; then
    echo "[include custom.cfg] already present in printer.cfg."
else
    echo "Backing up printer.cfg to printer.cfg.bak..."
    cp "$CONFIG_PATH" "${CONFIG_PATH}.bak"
    echo "Adding [include custom.cfg] to printer.cfg..."
    sed -i '1i [include custom.cfg]' "$CONFIG_PATH"
fi

# 3. Modify existing lines directly in printer.cfg via Python
echo "Applying direct edits to printer.cfg..."
python3 - "$CONFIG_PATH" << 'EOF'
import sys
import re

path = sys.argv[1]
with open(path, 'r') as f:
    content = f.read()

# Modify [tmc2209 extruder] run_current using \g<1> to prevent group parsing errors
content = re.sub(r'(\[tmc2209 extruder\][^\[]*?run_current:\s*)[\d.]+', r'\g<1>0.6', content)

# Modify [heater_generic chamber] max_temp
content = re.sub(r'(\[heater_generic chamber\][^\[]*?max_temp:\s*)\d+', r'\g<1>70', content)

# Modify [controller_fan board_fan] stepper
content = re.sub(r'(\[controller_fan board_fan\][^\[]*?stepper:\s*)[^\n]*', r'\g<1>stepper_x,stepper_y', content)

# Enable driver_SLOPE_CONTROL:2 for tmc2240 x and y
content = re.sub(r'(\[tmc2240 stepper_x\][^\[]*?)#\s*(driver_SLOPE_CONTROL:\s*2)', r'\g<1>\2', content)
content = re.sub(r'(\[tmc2240 stepper_y\][^\[]*?)#\s*(driver_SLOPE_CONTROL:\s*2)', r'\g<1>\2', content)

with open(path, 'w') as f:
    f.write(content)
print("Direct edits applied successfully.")
EOF

echo "Configuration complete! Restart Klipper for changes to take effect."