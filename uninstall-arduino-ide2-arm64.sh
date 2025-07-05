#!/bin/bash
set -e

echo "🗑️ Uninstalling Arduino IDE 2 (ARM64)..."

echo "🔻 Removing installation from /opt..."
sudo rm -rf /opt/arduino-ide-arm64

echo "🗂️ Removing desktop shortcut..."
sudo rm -f /usr/share/applications/arduino-ide.desktop

echo "🖼️ Removing icon..."
sudo rm -f /usr/share/pixmaps/arduino-ide.png

echo "🧹 Removing source folder if present..."
if [ -d "arduino-ide" ]; then
  rm -rf arduino-ide
  echo "✅ Removed ./arduino-ide build folder."
else
  echo "⚠️ No build folder (./arduino-ide) found to remove."
fi

echo "🔄 Updating desktop database..."
sudo update-desktop-database

echo "✅ Arduino IDE 2 has been fully uninstalled!"
