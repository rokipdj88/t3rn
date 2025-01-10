#!/bin/bash
screen -S t3rn
# Logo Teks Menarik
echo "==============================================="
echo "  EEEEE   CCCCC   H   H   AAAAA  N   N  EEEEE  L        X   X   CCCCC   AAAAA  N   N  DDDD   RRRR   AAAAA  PPPP   N   N"
echo "  E       C       H   H   A   A  NN  N  E      L         X X   C       A   A  NN  N  D   D  R   R  A   A  P   P  NN  N"
echo "  EEEE    C       HHHHH   AAAAA  N N N  EEEE   L         X X   C       AAAAA  N N N  D   D  RRRR   AAAAA  PPPP   N N N"
echo "  E       C       H   H   A   A  N  NN  E      L         X X   C       A   A  N  NN  D   D  R   R  A   A  P      N  NN"
echo "  EEEEE   CCCCC   H   H   A   A  N   N  EEEEE  LLLLL     X X   CCCCC   A   A  N   N  DDDD   R   R  A   A  P      N   N"
echo "==============================================="
echo ""
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
