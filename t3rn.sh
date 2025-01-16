#!/bin/bash
# Colors
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}"
echo -e ' ███╗   ███╗  █████╗        ██╗ ██╗ ██╗  ██╗  █████╗  ██╗  ██╗  █████╗'
echo -e ' ████╗ ████║ ██╔══██╗       ██║ ██║ ██║ ██╔╝ ██╔══██╗ ██║  ██║ ██╔══██║'
echo -e ' ██╔████╔██║ ███████║       ██║ ██║ █████╔╝  ███████║  █████╔╝ ██║  ██║'
echo -e ' ██║╚██╔╝██║ ██╔══██║  ██║  ██║ ██║ ██╔═██╗  ██╔══██║    ██╔╝  ██║  ██║'
echo -e ' ██║ ╚═╝ ██║ ██║  ██║   █████╔╝ ██║ ██║  ██╗ ██║  ██║    ██║    █████╔╝'
echo -e ' ╚═╝     ╚═╝ ╚═╝  ╚═╝   ╚════╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝    ╚════╝'
echo -e "${NC}"
echo -e "Buy VPS 40K on Telegram Store: https://t.me/candrapn"
echo -e "-----------------------------------------------------"
sleep 5

# Download file executor baru v 0.33.0
echo 
echo -e "Menghapus Versi 0.33.0"
echo
rm executor-linux-v0.33.0.tar.gz & rm -rf executor
sleep 3
echo -e "Mendownload versi terbaru executor-linux-v0.35.0.tar.gz"
echo
wget https://github.com/t3rn/executor-release/releases/download/v0.35.0/executor-linux-v0.35.0.tar.gz
# Ekstrak file
tar -xzvf executor-linux-v0.35.0.tar.gz

sleep 5
# Pindah ke direktori executor
cd executor/executor/bin || { echo "Direktori tidak ditemukan!"; exit 1; }

# Minta input dari pengguna untuk PRIVATE_KEY_LOCAL (terlihat saat diketik)
echo -n "Masukkan PRIVATE KEY: "
read PRIVATE_KEY_LOCAL  # Input terlihat saat diketik
echo  # Baris baru setelah input

# Set variabel lingkungan
export NODE_ENV=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true
export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false

# Jalankan executor
./executor
