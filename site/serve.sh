#!/usr/bin/env bash
# Portfolio on LabNET (TV + other devices can load it)
# Local:  http://127.0.0.1:8099/aide/home/joshua/
# LAN:    http://192.168.20.100:8099/aide/home/joshua/
cd "$(dirname "$0")"
# Bind all interfaces so Samsung TV (.103) can reach um690 (.100)
exec python3 -m http.server 8099 --bind 0.0.0.0
