#!/bin/bash
# Colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}"
echo -e ' ███╗   ███╗  █████╗        ██╗ ██╗ ██╗  ██╗  █████╗  ██╗  ██╗  █████╗'
echo -e ' ████╗ ████║ ██╔══██╗       ██║ ██║ ██║ ██╔╝ ██╔══██╗ ██║  ██║ ██╔══██║'
echo -e ' ██╔████╔██║ ███████║       ██║ ██║ █████╔╝  ███████║  █████╔╝ ██║  ██║'
echo -e ' ██║╚██╔╝██║ ██╔══██║  ██║  ██║ ██║ ██╔═██╗  ██╔══██║    ██╔╝  ██║  ██║'
echo -e ' ██║ ╚═╝ ██║ ██║  ██║   █████╔╝ ██║ ██║  ██╗ ██║  ██║    ██║    █████╔╝'
echo -e ' ╚═╝     ╚═╝ ╚═╝  ╚═╝   ╚════╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝    ╚════╝'
echo -e "${NC}"

echo -e "${BLUE}Join our Telegram channel: https://t.me/NTExhaust${NC}"
echo -e "${RED}-----------------------------------------------------${NC}"
echo -e "${BLUE}Buy VPS 40K on Telegram Store: https://t.me/candrapn${NC}"
sleep 5

# Menghapus file executor lama jika ada
echo
echo -e "Menghapus versi Sebelumnya "
rm executor-linux-v0.36.0.tar.gz
rm executor-linux-v0.37.0.tar.gz
rm executor-linux-v0.38.0.tar.gz
rm executor-linux-v0.39.0.tar.gz
rm executor-linux-v0.41.0.tar.gz
rm -rf t3rn
sleep 3
echo -e "Mendownload versi terbaru executor"
echo
mkdir -p t3rn
cd $HOME/t3rn

# Mengunduh rilis terbaru executor
curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
grep -Po '"tag_name": "\K.*?(?=")' | \
xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz
# Mengekstrak arsip
tar -xzf executor-linux-*.tar.gz

# Berpindah ke direktori binary executor
cd $HOME/t3rn/executor/executor/bin || { echo "Direktori tidak ditemukan!"; exit 1; }

# Meminta input manual untuk PRIVATE_KEY_LOCAL
echo -n "Masukkan PRIVATE KEY: "
read PRIVATE_KEY_LOCAL  # Input terlihat saat diketik
echo "PRIVATE KEY Anda: $PRIVATE_KEY_LOCAL"

# Meminta input manual untuk API ACLHEMY RPC
echo -n "Masukkan API ALCHEMY: "
read KEYALCHEMY  # Input terlihat saat diketik

# Memeriksa apakah KEYALCHEMY kosong
if [ -z "$KEYALCHEMY" ]; then
  echo "ALCHEMY API KEY kosong, melewati konfigurasi endpoint RPC untuk Alchemy."
else
  echo "ALCHEMY API KEY Anda: $KEYALCHEMY"
  export RPC_ENDPOINTS_ARBT="https://arb-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
  export RPC_ENDPOINTS_BSSP="https://base-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
  export RPC_ENDPOINTS_BLSS="https://blast-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
  export RPC_ENDPOINTS_OPSP="https://opt-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
fi

# Meminta input manual untuk EXECUTOR_MAX_L3_GAS_PRICE
echo -n "Masukkan nilai GAS PRICE (tekan Enter untuk default 100): "
read EXECUTOR_MAX_L3_GAS_PRICE

# Jika tidak diisi, gunakan nilai default 100
if [ -z "$EXECUTOR_MAX_L3_GAS_PRICE" ]; then
  EXECUTOR_MAX_L3_GAS_PRICE=100
fi

echo "GAS PRICE yang digunakan: $EXECUTOR_MAX_L3_GAS_PRICE"

# Menyiapkan variabel lingkungan
export NODE_ENV=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn'
export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
export EXECUTOR_MAX_L3_GAS_PRICE="$EXECUTOR_MAX_L3_GAS_PRICE"
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
export RPC_ENDPOINTS_L1RN='https://brn.calderarpc.com/'

# Menjalankan executor
echo -e "Menjalankan executor dengan konfigurasi saat ini..."
sleep 2
./executor
