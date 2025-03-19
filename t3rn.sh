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
loading 5
rm -f executor-linux-*.tar.gz
rm -rf t3rn
sleep 3

# Mengunduh versi terbaru
print_time
echo -e "📥 Downloading new version"
loading 3
mkdir -p t3rn
cd $HOME/t3rn
curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
grep -Po '"tag_name": "\K.*?(?=")' | \
xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz

tar -xzf executor-linux-*.tar.gz
cd $HOME/t3rn/executor/executor/bin || { echo "❌ Directory not found!"; exit 1; }

# Meminta input PRIVATE_KEY_LOCAL
print_time
loading 5
echo -n "🔑 Input your PRIVATE KEY : "
read -s PRIVATE_KEY_LOCAL
echo ""

echo -n "🔗 Input your Alchemy API KEY : "
read -s KEYALCHEMY
echo ""

if [ -z "$KEYALCHEMY" ]; then
  echo "⚠️ No API KEY, Skip Configuration Endpoint RPC for Alchemy."
  export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true
else
  echo "🔗 Your Alchemy API KEY : $KEYALCHEMY"
  export RPC_ENDPOINTS='{
    "l2rn": ["https://b2n.rpc.caldera.xyz/http"],
    "arbt": ["https://arb-sepolia.g.alchemy.com/v2/$KEYALCHEMY"],
    "bast": ["https://blast-sepolia.g.alchemy.com/v2/$KEYALCHEM"],
    "opst": ["https://opt-sepolia.g.alchemy.com/v2/$KEYALCHEMY"],
    "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"]
}'
#  export RPC_ENDPOINTS_ARBT="https://arb-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
#  export RPC_ENDPOINTS_BSSP="https://base-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
#  export RPC_ENDPOINTS_BLSS="https://blast-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
#  export RPC_ENDPOINTS_OPSP="https://opt-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
#  export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
fi

# Meminta input GAS FEE
echo -n "⛽ Set GAS FEE ( Enter for default 100 ): "
read EXECUTOR_MAX_L3_GAS_PRICE
if [ -z "$EXECUTOR_MAX_L3_GAS_PRICE" ]; then
  EXECUTOR_MAX_L3_GAS_PRICE=100
fi

print_time
loading 5
echo "⛽ GAS FEE : $EXECUTOR_MAX_L3_GAS_PRICE"

# Menyiapkan variabel lingkungan
export ENVIRONMENT=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l2rn'
export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
export EXECUTOR_MAX_L3_GAS_PRICE="$EXECUTOR_MAX_L3_GAS_PRICE"

# Menjalankan executor dengan screen
print_time
loading 5
echo -e "🚀 Running the executor inside a screen session."
sleep 2

# Membuat screen session otomatis
screen -dmS executor bash -c './executor; exec bash'
echo -e "✅ Executor is now running in a screen session. Use 'screen -r executor' to attach."

