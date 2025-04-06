#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e '\e[34m'
echo -e '$$\   $$\ $$$$$$$$\      $$$$$$$$\           $$\                                       $$\     '
echo -e '$$$\  $$ |\__$$  __|     $$  _____|          $$ |                                      $$ |    '
echo -e '$$$$\ $$ |   $$ |        $$ |      $$\   $$\ $$$$$$$\   $$$$$$\  $$\   $$\  $$$$$$$\ $$$$$$\   '
echo -e '$$ $$\$$ |   $$ |$$$$$$\ $$$$$\    \$$\ $$  |$$  __$$\  \____$$\ $$ |  $$ |$$  _____|\_$$  _|  '
echo -e '$$ \$$$$ |   $$ |\______|$$  __|    \$$$$  / $$ |  $$ | $$$$$$$ |$$ |  $$ |\$$$$$$\    $$ |    '
echo -e '$$ |\$$$ |   $$ |        $$ |       $$  $$<  $$ |  $$ |$$  __$$ |$$ |  $$ | \____$$\   $$ |$$\ '
echo -e '$$ | \$$ |   $$ |        $$$$$$$$\ $$  /\$$\ $$ |  $$ |\$$$$$$$ |\$$$$$$  |$$$$$$$  |  \$$$$  |'
echo -e '\__|  \__|   \__|        \________|\__/  \__|\__|  \__| \_______| \______/ \_______/    \____/ '
echo -e '\e[0m'
echo -e "Join our Telegram channel: https://t.me/NTExhaust"
sleep 5

# Fungsi print waktu
print_time() {
  echo -e "${CYAN}⏳ [$(date +"%Y-%m-%d %H:%M:%S")]${NC}"
}

# Fungsi animasi loading
loading() {
  local duration=$1
  local interval=0.2
  local end_time=$((SECONDS+duration))
  while [ $SECONDS -lt $end_time ]; do
    for s in . .. ...; do
      echo -ne "\r${CYAN}🔄 Loading processing${s}${NC} "
      sleep $interval
    done
  done
  echo -ne "\r${CYAN}✅ Proses complete.          ${NC}\n"
}

# Menghapus versi lama
print_time
echo -e "🗑️ Deleting old version."
loading 1
rm -f executor-linux-*.tar.gz
rm -rf t3rn
sleep 2

print_time
echo -e "📥 Downloading new version"
loading 1

mkdir -p $HOME/t3rn
cd $HOME/t3rn

# Input versi
echo -e "LIST EXECUTOR VERSION HERE : https://github.com/t3rn/executor-release/releases/"
read -p "Enter spesific version ex: v0.53.1 (press enter for the latest version): " VERSION
if [[ -z "$VERSION" ]]; then
    VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
        grep -Po '"tag_name": "\K.*?(?=")')
fi

echo -e "${YELLOW}📌 Downloading version: $VERSION${NC}"
wget https://github.com/t3rn/executor-release/releases/download/$VERSION/executor-linux-$VERSION.tar.gz || {
  echo -e "${RED}❌ Failed to download executor. Please check the version or your internet connection.${NC}"
  exit 1
}

tar -xzf executor-linux-*.tar.gz
cd $HOME/t3rn/executor/executor/bin || {
  echo -e "${RED}❌ Directory executor/executor/bin not found after extraction.${NC}"
  exit 1
}

echo -e "${GREEN}✅ Installation of version $VERSION completed!${NC}"

# PRIVATE KEY
print_time
loading 2
echo -n "🔑 Input your PRIVATE KEY : "
read PRIVATE_KEY_LOCAL
echo ""

# GAS FEE
echo -n "⛽ Set GAS FEE ( Enter for default 1000 ): "
read EXECUTOR_MAX_L3_GAS_PRICE
if [ -z "$EXECUTOR_MAX_L3_GAS_PRICE" ]; then
  EXECUTOR_MAX_L3_GAS_PRICE=1000
fi

print_time
loading 2
echo "⛽ GAS FEE : $EXECUTOR_MAX_L3_GAS_PRICE"

# Pilihan RPC Alchemy
echo -n "🌐 Use Alchemy RPC? (y/n): "
read USE_ALCHEMY

if [[ "$USE_ALCHEMY" == "y" || "$USE_ALCHEMY" == "Y" ]]; then
    echo -n "🔑 Enter your Alchemy API Key: "
    read API_ALCHEMY

    export RPC_ENDPOINTS='{
        "l2rn": ["https://t3rn-b2n.blockpi.network/v1/rpc/public", "https://b2n.rpc.caldera.xyz/http"],
        "arbt": ["https://arb-sepolia.g.alchemy.com/v2/'"$API_ALCHEMY"'"],
        "bast": ["https://base-sepolia.g.alchemy.com/v2/'"$API_ALCHEMY"'"],
        "blst": ["https://blast-sepolia.g.alchemy.com/v2/'"$API_ALCHEMY"'"],
        "opst": ["https://opt-sepolia.g.alchemy.com/'"$API_ALCHEMY"'"],
        "unit": ["https://unichain-sepolia.g.alchemy.com/v2/'"$API_ALCHEMY"'"]
    }'
else
    export RPC_ENDPOINTS='{
        "l2rn": ["https://t3rn-b2n.blockpi.network/v1/rpc/public", "https://b2n.rpc.caldera.xyz/http"],
        "arbt": ["https://arbitrum-sepolia.drpc.org", "https://sepolia-rollup.arbitrum.io/rpc"],
        "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.drpc.org"],
        "blst": ["https://sepolia.blast.io", "https://blast-sepolia.drpc.org"],
        "opst": ["https://sepolia.optimism.io", "https://optimism-sepolia.drpc.org"],
        "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"]
    }'
fi

# Variabel lingkungan lainnya
export ENVIRONMENT=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,unichain-sepolia,l2rn'
export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
export EXECUTOR_ENABLE_BATCH_BIDING=true
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
export EXECUTOR_PROCESS_ORDERS_API_ENABLED=false
export EXECUTOR_MAX_L3_GAS_PRICE="$EXECUTOR_MAX_L3_GAS_PRICE"

# Menjalankan dengan screen
print_time
loading 2
echo -e "🚀 Running the executor inside a screen session."
sleep 2
screen -dmS executor bash -c './executor; exec bash'
echo -e "${GREEN}✅ Executor is now running in a screen session. Use 'screen -r executor' to attach.${NC}"
