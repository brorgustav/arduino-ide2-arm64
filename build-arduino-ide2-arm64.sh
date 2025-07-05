#!/bin/bash
set -e

# Arduino IDE 2.x build script for Raspberry Pi ARM64

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y git curl build-essential \
    libgtk-3-dev \
    python3 python3-pip \
    golang-go \
    nodejs npm \
    libnss3 libxss1 libasound2 \
    desktop-file-utils

echo "📥 Installing yarn..."
sudo npm install -g yarn

echo "📁 Cloning Arduino IDE 2 source..."
git clone --depth 1 https://github.com/AirysDark/arduino-ide.git
cd arduino-ide

# Install NodeJS dependencies
echo "📦 Installing Node.js and Electron dependencies with yarn..."
yarn install

# Download arduino-cli for ARM64
echo "⬇️  Downloading arduino-cli for ARM64..."
curl -fsSL https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_ARM64.tar.gz | tar -xz


# Place arduino-cli binary in the correct location for the IDE
echo "📂 Placing arduino-cli in resources/app..."
mkdir -p resources/app/
mv arduino-cli resources/app/
chmod +x resources/app/arduino-cli

# Set build environment
export TARGET_ARCH=arm64

# Build the Electron-based frontend and backend
echo "🛠️  Building the Arduino IDE for ARM64..."
yarn electron:build --linux arm64

echo "🧱 Building frontend (Electron UI)..."
yarn install --frozen-lockfile --network-concurrency=4 --mutex network
yarn electron:build

echo "📦 Installing IDE to /opt/arduino-ide-arm64..."
sudo rm -rf /opt/arduino-ide-arm64
sudo cp -r dist/linux-arm64-unpacked /opt/arduino-ide-arm64

echo "🖼️ Installing desktop entry..."
sudo tee /usr/share/applications/arduino-ide.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Arduino IDE 2
Comment=Next-gen Arduino IDE
Exec=/opt/arduino-ide-arm64/arduino-ide
Icon=arduino-ide
Terminal=false
Type=Application
Categories=Development;IDE;Electronics;
StartupWMClass=arduino-ide
EOF

echo "🔗 Creating icon link..."
sudo cp resources/icons/icon.png /opt/arduino-ide-arm64/arduino-ide.png
sudo ln -sf /opt/arduino-ide-arm64/arduino-ide.png /usr/share/pixmaps/arduino-ide.png

echo "🔄 Updating desktop database..."
sudo update-desktop-database

echo "✅ Arduino IDE 2 installed!"
echo "You can now launch it from the menu or run:"
echo "/opt/arduino-ide-arm64/arduino-ide"
