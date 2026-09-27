``{=markdown}
#!/bin/bash

# Qidi Q2 Resource Optimizer Script
# Disables unused background services to free up system resources.

SERVICES=(
    "QIDILink-client.service"
    "strongswan-starter.service"
    "bluetoothtd.service  NO"
    "pulseaudio.service  NO"
    "xl2tpd.service"
    "triggerhappy.service"
    "openvpn.service"
    "lightdm.service"
    "algo_app.service"
)

echo "Starting Qidi Q2 resource optimization..."

for service in "${SERVICES[@]}"; do
    echo "Disabling and stopping $service..."
    sudo systemctl stop "$service" 2>/dev/null
    sudo systemctl disable "$service" 2>/dev/null
done

echo "Optimization complete! Restart your printer for best results."
``