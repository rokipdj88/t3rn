const { ethers } = require("ethers");
const { Web3 } = require("web3");
const axios = require("axios");
const readline = require("readline");

// === INPUT PROMPT ===
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const question = (query) => new Promise(resolve => rl.question(query, resolve));

(async () => {
  const address = await question("🏦 Enter your wallet address: ");
  const TELEGRAM_TOKEN = await question("🤖 Enter your Telegram Bot Token: ");
  const CHAT_ID = await question("💬 Enter your Telegram Chat ID: ");
  const apiAlchemy = await question("🔑 Enter your Alchemy API Key (leave blank to skip): ");
  rl.close();

  const BRN_RPC = "https://b2n.rpc.caldera.xyz/http";

  const RPC_ENDPOINTS = apiAlchemy
    ? {
        arbt: [`https://arb-sepolia.g.alchemy.com/v2/${apiAlchemy}`],
        bast: [`https://base-sepolia.g.alchemy.com/v2/${apiAlchemy}`],
        blst: [`https://blast-sepolia.g.alchemy.com/v2/${apiAlchemy}`],
        opst: [`https://opt-sepolia.g.alchemy.com/v2/${apiAlchemy}`],
        unit: [`https://unichain-sepolia.g.alchemy.com/v2/${apiAlchemy}`],
        mont: ["https://testnet-rpc.monad.xyz"]
      }
    : {
        arbt: ["https://arbitrum-sepolia.drpc.org"],
        bast: ["https://base-sepolia-rpc.publicnode.com"],
        blst: ["https://sepolia.blast.io"],
        opst: ["https://sepolia.optimism.io"],
        unit: ["https://unichain-sepolia.drpc.org"],
        mont: ["https://testnet-rpc.monad.xyz"]
      };

  const chainEmojis = {
    arbt: "🧠 Arbitrum",
    bast: "🦴 Base",
    blst: "🚀 Blast",
    opst: "⚡ Optimism",
    unit: "🪐 Unichain",
    brn:  "🔥 BRN",
    mont: "📀 Monad"
  };

  async function getBalance(providerUrl) {
    try {
      const provider = new ethers.JsonRpcProvider(providerUrl);
      const balance = await provider.getBalance(address);
      return ethers.formatEther(balance);
    } catch (err) {
      console.error(`❌ Failed to connect to ${providerUrl}:`, err.message);
      return null;
    }
  }

  async function getBrnBalance() {
    try {
      const web3 = new Web3(BRN_RPC);
      const balanceWei = await web3.eth.getBalance(address);
      return web3.utils.fromWei(balanceWei, "ether");
    } catch (err) {
      console.error("❌ Failed to fetch BRN balance:", err.message);
      return null;
    }
  }

  async function sendToTelegram(text) {
    try {
      await axios.post(`https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage`, {
        chat_id: CHAT_ID,
        text: text,
        parse_mode: "Markdown"
      });
      console.log("✅ Message sent to Telegram.");
    } catch (err) {
      console.error("❌ Failed to send Telegram message:", err.message);
    }
  }

  async function checkAndSend() {
    let message = 
`📝 *NTExhaust REPORT* 📝
🔥 *T3rn Executor* 🔥

💼 *Wallet Address:*
\`${address}\`

💰 *Current Balances:*`;

    for (const [chain, urls] of Object.entries(RPC_ENDPOINTS)) {
      const balance = await getBalance(urls[0]);
      message += balance !== null
        ? `\n• ${chainEmojis[chain]}: \`${balance} ETH\``
        : `\n• ${chainEmojis[chain]}: ❌ Failed to fetch`;
    }

    const brnBalance = await getBrnBalance();
    message += brnBalance !== null
      ? `\n• ${chainEmojis.brn}: \`${brnBalance} BRN\``
      : `\n• ${chainEmojis.brn}: ❌ Failed to fetch`;

    await sendToTelegram(message);
  }

  await checkAndSend();
  setInterval(checkAndSend, 10 * 60 * 1000); // Every 10 minutes
})();
