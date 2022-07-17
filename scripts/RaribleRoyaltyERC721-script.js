const hre = require("hardhat");

async function main() {
  const RoyaltyNFT = await hre.ethers.getContractFactory("RoyaltyNFT");
  const royaltyNFT = await RoyaltyNFT.deploy();

  await royaltyNFT.deployed();

  console.log("RoyaltyNFT deployed to:", royaltyNFT.address);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();
