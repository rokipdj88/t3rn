#!/bin/bash
# Colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'


print_time() {
  echo -e "${BLUE}[$(date +"%Y-%m-%d %H:%M:%S")]${NC}"
}

loading() {
  local duration=$1
  local interval=0.2
  local end_time=$((SECONDS+duration))
  while [ $SECONDS -lt $end_time ]; do
    for s in . .. ...; do
      echo -ne "\r${BLUE}Loading processing${s}${NC} "
      sleep $interval
    done
  done
  echo -ne "\r${BLUE}Proses complete.          ${NC}\n"
}

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


echo
print_time
echo -e "Deleting old version."
loading 5
rm executor-linux-v0.46.0.tar.gz
rm -rf t3rn
sleep 3
print_time
echo -e "Downloading new version"
loading 3
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
cd $HOME/t3rn/executor/executor/bin || { echo "Directory not found!"; exit 1; }

# Meminta input manual untuk PRIVATE_KEY_LOCAL
print_time
loading 5
echo -n "Input your PRIVATE KEY : "
read PRIVATE_KEY_LOCAL  # Input terlihat saat diketik
echo "PIVATE KEY: $PRIVATE_KEY_LOCAL"

# Meminta input manual untuk API ACLHEMY RPC
echo -n "Input your Alchemy API KEY : "
read KEYALCHEMY  # Input terlihat saat diketik

# Memeriksa apakah KEYALCHEMY kosong
if [ -z "$KEYALCHEMY" ]; then
  echo "No API KEY, Skip Configuration Endpoint RPC for Alchemy."
else
  echo "Your Alchemy API KEY : $KEYALCHEMY"
  export RPC_ENDPOINTS_ARBT="https://arb-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
  export RPC_ENDPOINTS_BSSP="https://base-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
  export RPC_ENDPOINTS_BLSS="https://blast-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
  export RPC_ENDPOINTS_OPSP="https://opt-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
fi

# Meminta input manual untuk EXECUTOR_MAX_L3_GAS_PRICE
print_time
loading 5
echo -n "Set GAS FEE ( Enter for default 100 ): "
read EXECUTOR_MAX_L3_GAS_PRICE

# Jika tidak diisi, gunakan nilai default 100
if [ -z "$EXECUTOR_MAX_L3_GAS_PRICE" ]; then
  EXECUTOR_MAX_L3_GAS_PRICE=100
fi

print_time
loading 5
echo "GAS FEE : $EXECUTOR_MAX_L3_GAS_PRICE"

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
print_time
loading 5
echo -e "Running the executor."
sleep 2
./executor
