# 🛠️ Arduino IDE 2 ARM64 Builder

A fully automated shell script to **build and install Arduino IDE 2.x from source** on **ARM64 Linux**, designed for **Raspberry Pi 4/5** and compatible boards.

## 🚀 Features

- **📦 Full Dependency Setup**  
  Installs all required tools: Node.js, Go, Python3, GTK3, Electron, and more.

- **⚡ Optimized Parallel Build**  
  Faster installation using `yarn` with network concurrency.

- **🔧 Builds From Source**  
  - Backend (`arduino-cli`)
  - Frontend (Electron UI)

- **📁 Installs to `/opt/arduino-ide-arm64`**

- **🖼️ Desktop & Start Menu Integration**  
  Adds application launcher and icon to your menu automatically.

- **🧹 Includes Uninstall Script**  
  Easily remove IDE, icon, and source with one command.

- **🧪 Raspberry Pi 64-bit Ready**

## 📋 Requirements

- ARM64-based Linux (e.g. Raspberry Pi OS 64-bit)
- ~3GB free space
- Internet connection

## 📥 Installation
```bash
sudo apt update
sudo apt-get install git
git clone https://github.com/AirysDark/arduino-ide2-arm64.git
cd arduino-ide2-arm64
chmod +x build-arduino-ide2-arm64.sh
./build-arduino-ide2-arm64.sh
```

```bash
git clone https://github.com/AirysDark/arduino-ide2-arm64.git
```
## Change directory
```
cd arduino-ide2-arm64
```
## Exacute script
```
chmod +x build-arduino-ide2-arm64.sh
./build-arduino-ide2-arm64.sh
```

## 🗑️ Uninstallation

```bash
chmod +x uninstall-arduino-ide2-arm64.sh
./uninstall-arduino-ide2-arm64.sh
```

## 📁 File Structure

```
arduino-ide-arm64/
├── build-arduino-ide2-arm64.sh       # Main build + install script
├── uninstall-arduino-ide2-arm64.sh   # Cleanup script
└── README.md
```

## 🧑‍💻 Credits

- Based on [arduino/arduino-ide](https://github.com/arduino/arduino-ide)
- Script by: Your Name or GitHub username

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).


## error fix
```bash
sudo apt install -y python3 make g++ gcc libx11-dev libxtst-dev libxkbfile-dev
npm config set python $(which python3)
rm -rf node_modules
rm package-lock.json yarn.lock
npm cache clean --force
yarn install --network-concurrency=4 --mutex network
npm config set build_from_source false
npm_config_build_from_source=false yarn install
node -v
python3 --version
npm config get python
sudo apt install -y python3 make g++ gcc libx11-dev libxtst-dev libxkbfile-dev
npm config set python $(which python3)
npm config set build_from_source false
cd ~/arduino-ide # or your IDE folder
rm -rf node_modules yarn.lock
yarn install --network-concurrency=4 --mutex network
export PYTHON=$(which python3)
export npm_config_python=$(which python3)
export npm_config_build_from_source=false
yarn install --network-concurrency=4 --mutex network
```
