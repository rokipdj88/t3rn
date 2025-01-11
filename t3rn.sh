#!/bin/bash
# Logo Teks Menarik
echo "#######################################"
echo "#                                     #"
echo "#            M A J I K A Y O         #"
echo "#                                     #"
echo "#######################################"
echo "\nWelcome to the installation script!\n"
echo "==============================================="
echo "BELI VPS DI @candrapn"
echo "==============================================="

# Jeda 5 detik
sleep 5

# Pindah ke direktori executor
cd executor/executor/bin || { echo "Direktori tidak ditemukan!"; exit 1; }

# Minta input dari pengguna untuk PRIVATE_KEY_LOCAL
echo -n "Masukkan nilai PRIVATE_KEY_LOCAL: "
read -s PRIVATE_KEY_LOCAL  # Input rahasia (tidak terlihat saat diketik)
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
