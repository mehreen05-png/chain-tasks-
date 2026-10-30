# Chain Tasks: To-Do List on Blockchain

A smart contract (Solidity) + Hardhat project + a plain HTML frontend. No framework needed.

## 1. Setup
```bash
npm install
cp .env.example .env     # Windows: copy .env.example .env
```

## 2. Test locally
```bash
npm test
```

## 3. Try it on your own computer (optional)
```bash
npm run node                 # terminal 1: local blockchain
npm run deploy:local         # terminal 2: deploys + writes frontend/config.js
npm run serve                # terminal 2: open the printed URL
```
(Add the local network to MetaMask: RPC http://127.0.0.1:8545, chain ID 31337.
Then change `chainId` handling by using the local network when asked.)

## 4. Deploy to Sepolia (free test network)
1. Create a NEW MetaMask wallet used only for testing. Export its private key into `.env` (`PRIVATE_KEY`).
2. Get a free RPC URL from Alchemy or Infura and put it in `.env` (`SEPOLIA_RPC_URL`).
3. Get free test ETH from a Sepolia faucet (Google Cloud Web3 faucet, Alchemy faucet, or PoW faucet).
4. Run:
```bash
npm run deploy:sepolia
```
This prints your contract address and writes `frontend/config.js` automatically.

## 5. Host the frontend for free
Upload the `frontend/` folder to Netlify Drop (app.netlify.com/drop), Vercel, GitHub Pages, or Cloudflare Pages.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
