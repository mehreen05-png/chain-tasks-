const fs = require("fs");
const path = require("path");
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const todo = await (await hre.ethers.getContractFactory("TodoList")).deploy();
  await todo.waitForDeployment();
  const address = await todo.getAddress();
  console.log("TodoList deployed to:", address);

  // Write address + ABI so the frontend works without manual copy-paste
  const artifact = await hre.artifacts.readArtifact("TodoList");
  const chainId = Number((await hre.ethers.provider.getNetwork()).chainId);
  const config = `window.TODO_CONFIG = ${JSON.stringify(
    { address, chainId, abi: artifact.abi },
    null,
    2
  )};\n`;
  fs.writeFileSync(path.join(__dirname, "..", "frontend", "config.js"), config);
  console.log("Frontend config written to frontend/config.js");

  if (hre.network.name === "sepolia" && process.env.ETHERSCAN_API_KEY) {
    console.log("Waiting for block confirmations before verifying...");
    await todo.deploymentTransaction().wait(5);
    try {
      await hre.run("verify:verify", { address, constructorArguments: [] });
    } catch (e) {
      console.log("Verification skipped:", e.message);
    }
  }
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
