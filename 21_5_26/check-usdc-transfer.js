const { ethers } = require("ethers");

// CONFIG
const RPC_URL = "https://base-rpc.publicnode.com";
const USDC_BASE = "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913";
const TARGET_WALLET = "0xE1Ae6321875Ea0B999213f1fD7cD118FD9663332".toLowerCase();

const POLL_INTERVAL_MS = 5000;

const ERC20_ABI = [
  "event Transfer(address indexed from, address indexed to, uint256 value)"
];

async function main() {
  const provider = new ethers.JsonRpcProvider(RPC_URL);

  const usdc = new ethers.Contract(
    USDC_BASE,
    ERC20_ABI,
    provider
  );

  let lastCheckedBlock = await provider.getBlockNumber();

  console.log("Esperando transferencias de USDC...");
  console.log("Wallet destino:", TARGET_WALLET);
  console.log("Bloque inicial:", lastCheckedBlock);

  while (true) {
    try {
      const latestBlock = await provider.getBlockNumber();

      if (latestBlock > lastCheckedBlock) {
        const fromBlock = lastCheckedBlock + 1;
        const toBlock = latestBlock;

        console.log(`Revisando bloques ${fromBlock} -> ${toBlock}`);

        const filter = usdc.filters.Transfer(null, TARGET_WALLET);

        const logs = await usdc.queryFilter(
          filter,
          fromBlock,
          toBlock
        );

        for (const log of logs) {
          const amount = ethers.formatUnits(log.args.value, 6);

          console.log("\n=== USDC RECIBIDO ===");
          console.log("From:", log.args.from);
          console.log("To:", log.args.to);
          console.log("Amount:", amount, "USDC");
          console.log("TxHash:", log.transactionHash);
          console.log("Block:", log.blockNumber);
          console.log(
            "Explorer:",
            `https://basescan.org/tx/${log.transactionHash}`
          );
        }

        lastCheckedBlock = latestBlock;
      }
    } catch (err) {
      console.error("Error:", err.message);
    }

    await new Promise((resolve) =>
      setTimeout(resolve, POLL_INTERVAL_MS)
    );
  }
}

main().catch(console.error);