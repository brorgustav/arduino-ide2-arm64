#!/bin/bash
set -e

# 🧰 Arduino IDE 2.x Build Script for Raspberry Pi OS ARM64
# ✅ Supports Go ≥1.21, Node.js ≥20, node-gyp, yarn workspaces, electron-builder
# Author: AirysDark (patched and finalised by ChatGPT)

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing required dependencies..."
sudo apt install -y git curl build-essential \
    libgtk-3-dev libnss3 libxss1 libasound2t64 \
    desktop-file-utils libudev-dev xz-utils \
    python3 python3-pip libx11-dev libxtst-dev \
    libxkbfile-dev make g++ gcc wget

echo "⬆️  Installing Node.js v20 (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "📥 Installing Yarn globally..."
sudo npm install -g yarn

# === GO INSTALL CHECK ===
NEED_GO=true
if command -v go >/dev/null 2>&1; then
    GOVERSION=$(go version | awk '{print $3}' | sed 's/go//')
    echo "📌 Found Go version: $GOVERSION"
    if [ "$(printf '%s\n' "1.21.0" "$GOVERSION" | sort -V | head -n1)" = "1.21.0" ]; then
        echo "✅ Go version is ≥ 1.21 — skipping install."
        NEED_GO=false
    else
        echo "⚠️ Go version is too old — reinstalling."
    fi
else
    echo "❌ Go not found — installing."
fi

if [ "$NEED_GO" = true ]; then
    echo "🧹 Removing old Go installation if present..."
    sudo apt remove --purge -y golang-go || true
    sudo rm -rf /usr/local/go

    echo "⬇️  Installing Go 1.22.3 (ARM64)..."
    cd ~
    wget -q https://go.dev/dl/go1.22.3.linux-arm64.tar.gz
    sudo tar -C /usr/local -xzf go1.22.3.linux-arm64.tar.gz

    echo "🔧 Setting up Go environment..."
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    export PATH=$PATH:/usr/local/go/bin
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    echo "✅ Go version installed: $(go version)"
else
    echo "🔁 Ensuring Go environment variables are set..."
    export PATH=$PATH:/usr/local/go/bin
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
fi

echo "📁 Cloning Arduino IDE source..."
git clone --depth 1 https://github.com/AirysDark/arduino-ide.git arduino-ide-arm64
cd arduino-ide-arm64

echo "🧹 Cleaning previous installs (if any)..."
rm -rf node_modules yarn.lock

echo "🔧 Setting environment for node-gyp with Python 3..."
export PYTHON=$(which python3)
export npm_config_python=$(which python3)
export npm_config_build_from_source=false

echo "📦 Installing dependencies with Yarn..."
yarn install --network-concurrency=4 --mutex network

echo "📦 Adding electron-builder to workspace root..."
yarn add -W electron-builder --dev

echo "⬇️  Downloading arduino-cli for ARM64..."
curl -fsSL https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_ARM64.tar.gz | tar -xz

echo "📂 Placing arduino-cli into resources/app/bin..."
mkdir -p resources/app/bin
mv arduino-cli resources/app/bin/
chmod +x resources/app/bin/arduino-cli

echo "🛠️  Building the Arduino IDE for Linux ARM64..."
yarn electron:build --linux --arm64

echo "📦 Installing IDE to /opt/arduino-ide-arm64..."
sudo rm -rf /opt/arduino-ide-arm64
sudo cp -r dist/linux-arm64-unpacked /opt/arduino-ide-arm64

echo "🖼️  Installing icon and desktop entry..."
sudo cp resources/icons/icon.png /opt/arduino-ide-arm64/arduino-ide.png
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

sudo ln -sf /opt/arduino-ide-arm64/arduino-ide.png /usr/share/pixmaps/arduino-ide.png
sudo update-desktop-database

echo "✅ Arduino IDE 2 has been successfully built and installed!"
echo "👉 Launch it from your menu or run:"
echo "   /opt/arduino-ide-arm64/arduino-ide"
